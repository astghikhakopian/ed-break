//
//  ScheduleModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.12.22.
//

import Foundation
import DeviceActivity
import FamilyControls


import Foundation
import FamilyControls
import DeviceActivity
import ManagedSettings

extension DeviceActivityName {
    static let daily = Self("daily")
}

extension DeviceActivityEvent.Name {
    static let encouraged = Self("encouraged")
}

class ScheduleModel {
    
    static public func setSchedule(startTime: Date? = nil) {
        
        print("Setting up the schedule")
        
        let selectionToEncourage: FamilyActivitySelection? = UserDefaultsService().getObjectFromSuite(forKey: .ChildUser.selectionToEncourage)
        let encouraged = selectionToEncourage ?? FamilyActivitySelection()
        
        let localThreshold: DateComponents? = UserDefaultsService().getObjectFromSuite(forKey: .ChildUser.threshold)
        let threshold = localThreshold ?? DateComponents(minute: 2)
        
        let events: [DeviceActivityEvent.Name: DeviceActivityEvent] = [
            .encouraged: DeviceActivityEvent(
                applications: encouraged.applicationTokens,
                categories: encouraged.categoryTokens,
                webDomains: encouraged.webDomainTokens,
                threshold: threshold
            )
        ]
        
        let store = ManagedSettingsStore()
        let schedule = DeviceActivitySchedule(
            intervalStart: Calendar.current.dateComponents([.hour, .minute], from: Date()),
            intervalEnd: Calendar.current.dateComponents([.day, .hour, .minute], from: Date().oneDay),
            repeats: true
        )
        
        let center = DeviceActivityCenter()
        do {
            print("Started Monitoring")
            try center.startMonitoring(.daily, during: schedule, events: events)
        } catch {
            print("Error occured while started monitoring: ", error)
        }
        
        store.dateAndTime.requireAutomaticDateAndTime = true
        store.account.lockAccounts = true
        store.passcode.lockPasscode = true
        store.siri.denySiri = true
        store.appStore.denyInAppPurchases = true
        store.appStore.maximumRating = 1000
        store.appStore.requirePasswordForPurchases = true
        store.media.denyExplicitContent = true
        store.gameCenter.denyMultiplayerGaming = true
        store.media.denyMusicService = true
      store.webContent.blockedByFilter = .auto()
    }
}

extension Date {
    func toGMTTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    func toLocal() -> Date {
        let timezoneOffset = TimeZone.current.secondsFromGMT()
        let epochDate = self.timeIntervalSince1970
        let timezoneEpochOffset = (epochDate + Double(timezoneOffset))
        return Date(timeIntervalSince1970: timezoneEpochOffset)
    }
    var oneYear: Date {
        if let date = Calendar.current.date(byAdding: .day, value: 365, to: Date()) {
            return date
        }
        return Date()
    }
    var oneWeek: Date {
        if let date = Calendar.current.date(byAdding: DateComponents(hour: 4, second: 10), to: Date()) {
            return date
        }
        return Date()
    }
    var oneDay: Date {
        if let date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) {
            return date
        }
        return Date()
    }
    
}

