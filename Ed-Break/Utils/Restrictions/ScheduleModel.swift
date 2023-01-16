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
//        print("Current time is: ", Calendar.current.dateComponents([.hour, .minute], from: Date()).hour!)
//        let restrictions = "{\"categoryTokens\":[],\"untokenizedApplicationIdentifiers\":[],\"includeEntireCategory\":false,\"untokenizedWebDomainIdentifiers\":[],\"untokenizedCategoryIdentifiers\":[],\"applicationTokens\":[{\"data\":\"AAAAAAAAAAAAAAAAmV59QLkX83qzdD/iS3rAhLr/Lx1h0KgZFskZeLDwIw9GWh4tC/1TveqWenFC0EHjGNzJxYWFnFYAM/pYe0G2kYObo6uGACNVGhRQHWsrxui8al9pOzGWoNc7NhWQ1Rm7OgOI8A8psPrHj9RaHVq3OBdaRAc=\"}],\"webDomainTokens\":[]}".replacingOccurrences(of: "\\\"", with: "\"")
//        if let stringData = restrictions.data(using: .utf8),
//           let selectionObject = try? JSONDecoder().decode(FamilyActivitySelection.self, from: stringData) {
//            DataModel.shared.selectionToDiscourage = selectionObject
//            DataModel.shared.selectionToEncourage = selectionObject
//            DataModel.shared.threshold = DateComponents(hour: 1, minute: 24)
//        }
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
