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
    @Published var moveToChildDashboard: Bool = false
    @Published var moveToLogin: Bool = false
    @Published var moveToChildQR: Bool = false
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
    @State var isChildLoggedIn: Bool
    @State var waitingChild = false
    
    init() {
        let isLoggedIn: Bool? = UserDefaultsService().getPrimitive(forKey: .User.isLoggedIn)
        self.isLoggedIn = isLoggedIn ?? false
        
        let isChildLoggedIn: Bool? = UserDefaultsService().getPrimitive(forKey: .ChildUser.isLoggedIn)
        self.isChildLoggedIn = isChildLoggedIn ?? false
    }
    
    var body: some View {
        Group {
            if waitingChild {
                ChildQRView(viewModel: ChildQRViewModel(checkConnectionUseCase: CheckConnectionUseCase(childrenRepository: DefaultChildrenRepository()), localStorageService: UserDefaultsService()))
            } else {
                if isChildLoggedIn {
                    ChildTabView()
                        .environmentObject(model)
                } else if isLoggedIn {
                    TabBarView()
                        .environmentObject(model)
                } else {
                    OnboardingRole()
                }
            }
        }
        .onReceive(appState.$moveToDashboard) { moveToDashboard in
            guard moveToDashboard else { return }
            appState.moveToDashboard = false
            waitingChild = false
            isLoggedIn = true
        }
        .onReceive(appState.$moveToChildDashboard) { moveToChildDashboard in
            guard moveToChildDashboard else { return }
            appState.moveToChildDashboard = false
            waitingChild = false
            isChildLoggedIn = true
        }
        .onReceive(appState.$moveToLogin) { moveToLogin in
            guard moveToLogin else { return }
            appState.moveToLogin = false
            waitingChild = false
            isLoggedIn = false
            isChildLoggedIn = false
        }
        .onReceive(appState.$moveToChildQR) { moveToChildQR in
            guard moveToChildQR else { return }
            appState.moveToChildQR = false
            waitingChild = true
        }
        .onAppear {
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
