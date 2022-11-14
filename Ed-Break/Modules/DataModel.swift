//
//  DataModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 07.11.22.
//


import Foundation
import FamilyControls
import DeviceActivity
import ManagedSettings

//class MyModel: ObservableObject {
//    static let shared = MyModel()
//    let store = ManagedSettingsStore()
//
//    private init() {}
//
//    var selectionToDiscourage = FamilyActivitySelection() {
//        willSet {
//            print ("got here \(newValue)")
//            let applications = newValue.applicationTokens
//            let categories = newValue.categoryTokens
//            let webCategories = newValue.webDomainTokens
//            store.shield.applications = applications.isEmpty ? nil : applications
//            store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(categories, except: Set())
//            store.shield.webDomains = webCategories
//        }
//    }
//
//    func initiateMonitoring() {
//        let schedule = DeviceActivitySchedule(intervalStart: DateComponents(hour: 0, minute: 0), intervalEnd: DateComponents(hour: 0, minute: 15), repeats: true, warningTime: nil)
//
//        let center = DeviceActivityCenter()
//        do {
//            try center.startMonitoring(.daily, during: schedule)
//        }
//        catch {
//            print ("Could not start monitoring \(error)")
//        }
//
//        store.dateAndTime.requireAutomaticDateAndTime = true
//        store.account.lockAccounts = true
//        store.passcode.lockPasscode = true
//        store.siri.denySiri = true
//        store.appStore.denyInAppPurchases = true
//        store.appStore.maximumRating = 200
//        store.appStore.requirePasswordForPurchases = true
//        store.media.denyExplicitContent = true
//        store.gameCenter.denyMultiplayerGaming = true
//        store.media.denyMusicService = false
//    }
//}

extension DeviceActivityName {
    static let daily = Self("daily")
}


import Foundation
import FamilyControls
import ManagedSettings

private let _DataModel = DataModel()

open class DataModel: ObservableObject {
    let store = ManagedSettingsStore()
    
    @Published open var selectionToDiscourage: FamilyActivitySelection
    @Published open var selectionToEncourage: FamilyActivitySelection
    
    init() {
        selectionToDiscourage = FamilyActivitySelection()
        selectionToEncourage = FamilyActivitySelection()
    }
    
    open class var shared: DataModel {
        return _DataModel
    }
    
    func setShieldRestrictions() {
        // let apps = DataModel.shared.selectionToDiscourage
        let applications = DataModel.shared.selectionToDiscourage
        
        store.shield.applications = applications.applicationTokens.isEmpty ? nil : applications.applicationTokens
        store.shield.applicationCategories = applications.categoryTokens.isEmpty
        ? nil
        : ShieldSettings.ActivityCategoryPolicy.specific(applications.categoryTokens)
        ScheduleModel.setSchedule()
        /*
        let applications = apps.applicationTokens
        let q = try! JSONEncoder().encode(DataModel.shared.selectionToDiscourage)
        print(q)
        let p = try! JSONDecoder().decode(FamilyActivitySelection.self, from: q)
        print(p)
        
        let json = try! JSONSerialization.jsonObject(with: q, options: []) as? [String : Any]
        print(json)
        let categories = apps.categoryTokens
        let webCategories = apps.webDomainTokens
        store.shield.applications = applications.isEmpty ? nil : applications
        store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(categories, except: Set())
        store.shield.webDomains = webCategories
        
        ScheduleModel.setSchedule()
         */
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
    intervalStart: DateComponents(hour: 13, minute: 0),
    intervalEnd: DateComponents(hour: 14, minute: 15),
    repeats: true
)

class ScheduleModel {
    static public func setSchedule() {
        let store = ManagedSettingsStore()
                let schedule = DeviceActivitySchedule(intervalStart: DateComponents(hour: 12, minute: 0), intervalEnd: DateComponents(hour: 14, minute: 45), repeats: true, warningTime: nil)
        
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
        
        
        
//        print("Setting up the schedule")
//        print("Current time is: ", Calendar.current.dateComponents([.hour, .minute], from: Date()).hour!)
//
//        let events: [DeviceActivityEvent.Name: DeviceActivityEvent] = [
//            .encouraged: DeviceActivityEvent(
//                applications: DataModel.shared.selectionToEncourage.applicationTokens,
//                threshold: DateComponents(minute: 15)
//            )
//        ]
//
//        let center = DeviceActivityCenter()
//        do {
//            print("Started Monitoring")
//            try center.startMonitoring(.daily, during: schedule, events: events)
//        } catch {
//            print("Error occured while started monitoring: ", error)
//        }
    }
}
