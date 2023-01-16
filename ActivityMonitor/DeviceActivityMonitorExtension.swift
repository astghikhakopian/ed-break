//
//  DeviceActivityMonitorExtension.swift
//  ActivityMonitor
//
//  Created by Astghik Hakopian on 07.11.22.
//

import UIKit
import MobileCoreServices
import ManagedSettings
import DeviceActivity
import FamilyControls
import Foundation

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
   
    let store = ManagedSettingsStore()
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
//        let model = DataModel.shared
//        let applications = model.selectionToEncourage.applicationTokens
//        store.shield.applications = applications.isEmpty ? nil : applications
//        store.dateAndTime.requireAutomaticDateAndTime = true
//        DataModel.shared.setShieldRestrictions()
        
//        sendNotification(title: "interval did start \(applications)")
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        
//        store.shield.applications = nil
//        store.dateAndTime.requireAutomaticDateAndTime = false
        
//        sendNotification(title: "interval did end")
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        
//        let applications = DataModel.shared.selectionToEncourage
//        DataModel.shared.selectionToDiscourage = applications
//        DataModel.shared.selectionToEncourage = FamilyActivitySelection()
//        DataModel.shared.threshold = DateComponents()
//        DataModel.shared.setShieldRestrictions()
            
//        print(event, activity)
//        store.shield.applications = nil
//        let model = DataModel.shared
//        DispatchQueue.background(delay: 10.0, background: {
////            let store = ManagedSettingsStore()
//                        let model = DataModel.shared
////
//                        let applications = model.selectionToEncourage.applicationTokens
//                        model.selectionToDiscourage = FamilyActivitySelection()// model.selectionToEncourage
//                        model.selectionToEncourage = FamilyActivitySelection()
//                        model.threshold = DateComponents()
//                        //        let applications1 = model.selectionToDiscourage.applicationTokens
//                        //        let sum = applications.union(applications1)
//                        //        model.store.shield.applications = applications.isEmpty ? nil : sum//sum.isEmpty ? nil : sum
//                        //        let applications = DataModel.shared.selectionToDiscourage
//
////                        store.shield.applications = nil//applications.applicationTokens.isEmpty ? nil : applications.applicationTokens
////                        store.shield.applicationCategories = nil//applications.categoryTokens.isEmpty
//                        //        ? nil
//                        //        : ShieldSettings.ActivityCategoryPolicy.specific(applications.categoryTokens)
//
//            self.store.shield.applications = nil
//            self.store.shield.applicationCategories = nil
//            self.store.shield.webDomainCategories = nil
//            self.store.shield.webDomains = nil
//                        model.setShieldRestrictions()
////                    }
////
////                    sendNotification(title: "did reach threshold, \(event.rawValue), \(activity.rawValue), \(2)")
////                    ScheduleModel.setSchedule()
//        }, completion: { [weak self] in
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        // let apps: FamilyActivitySelection? = UserDefaultsService().getObject(forKey: .ChildUser.restrictedApps)
//            NotificationCenter.default.post(name: NSNotification.Name("a"), object: apps)
        sendNotification(title: "You reached the limit", body: "Answer the aditional questions and get more time.")
//        }
//        })
        
//            self?.store.shield.applications = nil
//            self?.store.shield.applicationCategories = nil
//            self?.store.shield.webDomainCategories = nil
//            self?.store.shield.webDomains = nil
//
//            DataModel.shared.setShieldRestrictions()
//        })
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            let store = ManagedSettingsStore()
//            let model = DataModel.shared
//
//            let applications = model.selectionToEncourage.applicationTokens
//            model.selectionToDiscourage = FamilyActivitySelection()// model.selectionToEncourage
//            model.selectionToEncourage = FamilyActivitySelection()
//            model.threshold = DateComponents()
//            //        let applications1 = model.selectionToDiscourage.applicationTokens
//            //        let sum = applications.union(applications1)
//            //        model.store.shield.applications = applications.isEmpty ? nil : sum//sum.isEmpty ? nil : sum
//            //        let applications = DataModel.shared.selectionToDiscourage
//
//            store.shield.applications = nil//applications.applicationTokens.isEmpty ? nil : applications.applicationTokens
//            store.shield.applicationCategories = nil//applications.categoryTokens.isEmpty
//            //        ? nil
//            //        : ShieldSettings.ActivityCategoryPolicy.specific(applications.categoryTokens)
//
//
//            model.setShieldRestrictions()
//        store.shield.applications = nil
//        store.dateAndTime.requireAutomaticDateAndTime = false
//        }
        
//        sendNotification(title: "did reach threshold, \(event.rawValue), \(activity.rawValue), \(1)")
//        ScheduleModel.setSchedule()
    }
    
    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        print(activity)
        // Handle the warning before the interval starts.
        // sendNotification(title: "interval will start warning, \(activity)")
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        print(activity)
        // Handle the warning before the interval ends.
        // sendNotification(title: "interval will end warning, \(activity)")
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        print(event, activity)
        // sendNotification(title: "will reach threshold, \(event), \(activity)")        // Handle the warning before the event reaches its threshold.
    }
}
let userNotificationCenter = UNUserNotificationCenter.current()

func sendNotification(title: String, body: String?) {
    requestNotificationAuthorization()
    let notificationContent = UNMutableNotificationContent()
    notificationContent.title = title
    notificationContent.body = body ?? title
    notificationContent.badge = NSNumber(value: 0)
    
    if let url = Bundle.main.url(forResource: "dune",
                                withExtension: "png") {
        if let attachment = try? UNNotificationAttachment(identifier: "dune",
                                                        url: url,
                                                        options: nil) {
            notificationContent.attachments = [attachment]
        }
    }
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1,
                                                    repeats: false)
    let request = UNNotificationRequest(identifier: "testNotification",
                                        content: notificationContent,
                                        trigger: trigger)
    
    userNotificationCenter.add(request) { (error) in
        if let error = error {
            print("Notification Error: ", error)
        }
    }
}

func requestNotificationAuthorization() {
    let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
    
    userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
        if let error = error {
            print("Error: ", error)
        }
    }
}
extension DispatchQueue {

    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }

}
