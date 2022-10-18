//
//  ContentView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 26.09.22.
//

import SwiftUI
import FamilyControls

class AppState: ObservableObject {
    @Published var moveToDashboard: Bool = false
}

//import SwiftUI
//import FamilyControls
//
//struct ContentView: View {
//    @State private var isDiscouragedPresented = false
//    @State private var isEncouragedPresented = false
//
//    @EnvironmentObject var model: DataModel
//
//    var body: some View {
//
//        VStack {
//            Button("Select Apps to Discourage") {
//                isDiscouragedPresented = true
//            }
//            .familyActivityPicker(isPresented: $isDiscouragedPresented, selection: $model.selectionToDiscourage)
//
//            Button("Select Apps to Encourage") {
//                isEncouragedPresented = true
//            }
//            .familyActivityPicker(isPresented: $isEncouragedPresented, selection: $model.selectionToEncourage)
//            Button("ewdsc") {
//                ScheduleModel.setSchedule()
//            }
//        }
//        .onChange(of: model.selectionToDiscourage) { newSelection in
//            DataModel.shared.setShieldRestrictions()
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//            .environmentObject(DataModel())
//    }
//}


//struct ContentView: View {
//    @StateObject var model = MyModel.shared
//    @State var isPresented = false
//
//    var body: some View {
//        Button("Select Apps to Discourage") {
//            isPresented = true
//        }
//        .familyActivityPicker(isPresented: $isPresented, selection: $model.selectionToDiscourage)
//        Button("Start Monitoring") {
//            model.initiateMonitoring()
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}


struct ContentView: View {
    
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var model: DataModel
    @State var isLoggedIn: Bool
    
    init() {
        let isLoggedIn: Bool? = UserDefaultsService().getPrimitive(forKey: .User.isLoggedIn)
        self.isLoggedIn = isLoggedIn ?? true
    }
    
    var body: some View {
        Group {
            if isLoggedIn {
//                 Allow2PairingView()
//                  Allow2RequestView()
                // Allow2BlockView()
                 TabBarView()
                    .environmentObject(model)
                
            } else {
                OnboardingRole()
            }
        }.onReceive(appState.$moveToDashboard) { moveToDashboard in
            guard moveToDashboard else { return }
            appState.moveToDashboard = false
            isLoggedIn = true
        }.onAppear {
            // Allow2.shared.deviceToken = UIDevice.current.identifierForVendor?.uuidString ?? ""
            // Allow2.shared.env = .sandbox
//            AuthorizationCenter.shared.requestAuthorization { result in
//                switch result {
//                case .success:
//                    print("Success")
//                case .failure(let error):
//                    print("error for screentime is \(error)")
//                }
//            }
//
//            _ = AuthorizationCenter.shared.$authorizationStatus
//                .sink() {_ in
//                    switch AuthorizationCenter.shared.authorizationStatus {
//                    case .notDetermined:
//                        print("not determined")
//                        AuthorizationCenter.shared.requestAuthorization { result in
//                            switch result {
//                            case .success:
//                                print("Success")
//                            case .failure(let error):
//                                print("error for screentime is \(error)")
//                            }
//                        }
//                    case .denied:
//                        print("denied")
//                    case .approved:
//                        print("approved")
//                    @unknown default:
//                        break
//                    }
//                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


import Foundation
import FamilyControls
import DeviceActivity
import ManagedSettings

class MyModel: ObservableObject {
    static let shared = MyModel()
    let store = ManagedSettingsStore()

    private init() {}

    var selectionToDiscourage = FamilyActivitySelection() {
        willSet {
            print ("got here \(newValue)")
            let applications = newValue.applicationTokens
            let categories = newValue.categoryTokens
            let webCategories = newValue.webDomainTokens
            store.shield.applications = applications.isEmpty ? nil : applications
            store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(categories, except: Set())
            store.shield.webDomains = webCategories
        }
    }

    func initiateMonitoring() {
        let schedule = DeviceActivitySchedule(intervalStart: DateComponents(hour: 0, minute: 0), intervalEnd: DateComponents(hour: 0, minute: 15), repeats: true, warningTime: nil)

        let center = DeviceActivityCenter()
        do {
            try center.startMonitoring(.daily, during: schedule)
        }
        catch {
            print ("Could not start monitoring \(error)")
        }

        store.dateAndTime.requireAutomaticDateAndTime = true
        store.account.lockAccounts = true
        store.passcode.lockPasscode = true
        store.siri.denySiri = true
        store.appStore.denyInAppPurchases = true
        store.appStore.maximumRating = 200
        store.appStore.requirePasswordForPurchases = true
        store.media.denyExplicitContent = true
        store.gameCenter.denyMultiplayerGaming = true
        store.media.denyMusicService = false
    }
}

extension DeviceActivityName {
    static let daily = Self("daily")
}


import Foundation
import FamilyControls
import ManagedSettings

private let _DataModel = DataModel()

class DataModel: ObservableObject {
    let store = ManagedSettingsStore()
    
    @Published var selectionToDiscourage: FamilyActivitySelection
    @Published var selectionToEncourage: FamilyActivitySelection
    
    init() {
        selectionToDiscourage = FamilyActivitySelection()
        selectionToEncourage = FamilyActivitySelection()
    }
    
    class var shared: DataModel {
        return _DataModel
    }
    
    func setShieldRestrictions() {
        let applications = DataModel.shared.selectionToDiscourage
        
        store.shield.applications = applications.applicationTokens.isEmpty ? nil : applications.applicationTokens
        store.shield.applicationCategories = applications.categoryTokens.isEmpty
        ? nil
        : ShieldSettings.ActivityCategoryPolicy.specific(applications.categoryTokens)
    }
}

import Foundation
import DeviceActivity

//extension DeviceActivityName {
//    static let daily = Self("daily")
//}

extension DeviceActivityEvent.Name {
    static let encouraged = Self("encouraged")
//    static let discouraged = Self("discouraged")
}

let schedule = DeviceActivitySchedule(
    intervalStart: DateComponents(hour: 0, minute: 0),
    intervalEnd: DateComponents(hour: 0, minute: 15),
    repeats: true
)

class ScheduleModel {
    static public func setSchedule() {
        print("Setting up the schedule")
        print("Current time is: ", Calendar.current.dateComponents([.hour, .minute], from: Date()).hour!)

        let events: [DeviceActivityEvent.Name: DeviceActivityEvent] = [
            .encouraged: DeviceActivityEvent(
                applications: DataModel.shared.selectionToEncourage.applicationTokens,
                threshold: DateComponents(minute: 5)
            )
        ]
        
        let center = DeviceActivityCenter()
        do {
            print("Started Monitoring")
            try center.startMonitoring(.daily, during: schedule, events: events)
        } catch {
            print("Error occured while started monitoring: ", error)
        }
    }
}
