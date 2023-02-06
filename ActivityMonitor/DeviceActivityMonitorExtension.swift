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

class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    
    let store = ManagedSettingsStore()
    private let userDefaultsService = UserDefaultsService()
    
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        
        setShieldRestrictions()
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        
        store.shield.applications = nil
        store.dateAndTime.requireAutomaticDateAndTime = false
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        
        let remindingLocalMinutes: Int? = self.userDefaultsService.getPrimitiveFromSuite(forKey: .ChildUser.remindingMinutes)
        
        let remindingMinutes = remindingLocalMinutes ?? 0
        
        if remindingMinutes > 1 {
            self.userDefaultsService.setPrimitiveInSuite(remindingMinutes-1, forKey: .ChildUser.remindingMinutes)
            ScheduleModel.setSchedule()
            sendNotification(title: "Ed-Break Reminder", body: "Reminding minute(s): \(remindingMinutes-1)")
        } else {
            self.userDefaultsService.setPrimitiveInSuite(0, forKey: .ChildUser.remindingMinutes)
            let savedApplications: FamilyActivitySelection? = userDefaultsService.getObjectFromSuite(forKey: .ChildUser.selectionToEncourage)
            let restrictions = savedApplications ?? FamilyActivitySelection()
            self.userDefaultsService.setObjectInSuite(DateComponents(), forKey: .ChildUser.threshold)
            self.userDefaultsService.setObjectInSuite(FamilyActivitySelection(), forKey: .ChildUser.selectionToEncourage)
            if !restrictions.categories.isEmpty ||
                !restrictions.categoryTokens.isEmpty ||
                !restrictions.applications.isEmpty ||
                !restrictions.applicationTokens.isEmpty ||
                !restrictions.webDomains.isEmpty ||
                !restrictions.webDomainTokens.isEmpty {
                self.userDefaultsService.setObjectInSuite(restrictions, forKey: .ChildUser.selectionToDiscourage)
            }
            
            DataModel.shared.selectionToDiscourage = restrictions
            DataModel.shared.selectionToEncourage = FamilyActivitySelection()
            DataModel.shared.threshold = DateComponents()
            
            setShieldRestrictions()
            sendNotification(title: "Ed-Break Shield", body: "Your time is over.")
        }
        
    }
    
    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        print(activity)
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        print(activity)
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        print(event, activity)
    }
    
    private func setShieldRestrictions() {
        
        let savedApplications: FamilyActivitySelection? = UserDefaultsService().getObjectFromSuite(forKey: .ChildUser.selectionToDiscourage)
        let selection = savedApplications ?? FamilyActivitySelection()
        DataModel.shared.selectionToDiscourage = selection
        DataModel.shared.setShieldRestrictions()
        
        let applications = selection.applicationTokens
        let categories = selection.categoryTokens
        let webCategories = selection.webDomainTokens
        
        store.shield.applications = applications.isEmpty ? nil : applications
        store.shield.applicationCategories = categories.isEmpty ? nil : ShieldSettings.ActivityCategoryPolicy.specific(categories, except: Set())
        store.shield.webDomains = webCategories.isEmpty ? nil : webCategories
        
        let isRestrected = !applications.isEmpty || !categories.isEmpty || !webCategories.isEmpty
        store.dateAndTime.requireAutomaticDateAndTime = isRestrected
        store.account.lockAccounts = isRestrected
        store.passcode.lockPasscode = isRestrected
        store.siri.denySiri = isRestrected
        store.appStore.denyInAppPurchases = isRestrected
        store.appStore.requirePasswordForPurchases = isRestrected
        store.media.denyExplicitContent = isRestrected
        store.gameCenter.denyMultiplayerGaming = isRestrected
        store.media.denyMusicService = isRestrected
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
