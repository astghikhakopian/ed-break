//
//  ScheduleModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.12.22.
//

import Foundation
import DeviceActivity
import FamilyControls

extension DeviceActivityName {
    static let daily = Self("daily")
}

extension DeviceActivityEvent.Name {
    static let encouraged = Self("encouraged")
}

let schedule = DeviceActivitySchedule(
    intervalStart: DateComponents(hour: 0, minute: 0),
    intervalEnd: DateComponents(hour: 23, minute: 59),
    repeats: true
)

class ScheduleModel {
    static public func setSchedule(startTime: Date? = nil) {
        print("Setting up the schedule")
        let events: [DeviceActivityEvent.Name: DeviceActivityEvent] = startTime == nil ? [:] : [
            .encouraged: DeviceActivityEvent(
                applications: DataModel.shared.selectionToEncourage.applicationTokens,
                threshold: DataModel.shared.threshold
            )
        ]
        let schedule = DeviceActivitySchedule(
            intervalStart: Calendar.current.dateComponents([.hour, .minute], from: startTime ?? Date()),
            intervalEnd: DateComponents(hour: 23, minute: 59),
            repeats: true
        )
        
        let center = DeviceActivityCenter()
        do {
            print("Started Monitoring")
            print(center.activities)
            try center.startMonitoring(.daily, during: schedule, events: events)
        } catch {
            print("Error occured while started monitoring: ", error)
        }
    }
    
}
