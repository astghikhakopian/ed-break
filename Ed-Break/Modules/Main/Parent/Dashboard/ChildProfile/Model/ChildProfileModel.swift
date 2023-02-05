//
//  ChildProfileModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 13.10.22.
//

import FamilyControls
import Foundation

struct ChildProfileModel: Equatable {
    
    let educationPeriod: TimePeriod
    let activityPeriod: TimePeriod
    let childId: Int
    let periodAnswers: Int
    let periodCorrectAnswers: Int
    let percentageForPeriod: Float
    let periodActivity: Float
    let averageActivity: Float
    let restrictionTime: Int
    let percentProgress: Int?
    let restrictions: FamilyActivitySelection?
    
    let lastLogin: Date?
    var lastLoginString: String {
        NSLocalizedString("main.parent.childProfile.lastActive", comment: "") +
        (lastLogin?.toStringWithRelativeTime() ?? "")
    }
    
    init(dto: ChildRetriveDto) {
        educationPeriod = TimePeriod(rawValue: dto.educationPeriod) ?? .day
        activityPeriod = TimePeriod(rawValue: dto.activityPeriod) ?? .day
        childId = dto.childId
        periodAnswers = dto.periodAnswers
        periodCorrectAnswers = dto.periodCorrectAnswers
        percentageForPeriod = dto.percentagesOfCorrectAnswers ?? 0
        lastLogin = Date(fromString: dto.lastLogin ?? "", format: .isoDateTimeFull)
        periodActivity = Float(Int(dto.periodActivity*10))/10
        averageActivity = Float(Int(dto.averageActivity*10))/10
        restrictionTime = dto.restrictionTime ?? 0
        percentProgress = dto.percentProgress
        
        if let restrictions = dto.restrictions?.replacingOccurrences(of: "\\\"", with: "\""),
           let stringData = restrictions.data(using: .utf8),
           let selectionObject = try? JSONDecoder().decode(FamilyActivitySelection.self, from: stringData) {
            self.restrictions = selectionObject
        } else {
            restrictions = nil
        }
    }
    
    init(childId: Int) {
        educationPeriod = TimePeriod.day
        activityPeriod = TimePeriod.day
        self.childId = childId
        periodAnswers = 0
        periodCorrectAnswers = 0
        percentageForPeriod = 0
        lastLogin = Date()
        periodActivity = 0
        averageActivity = 0
        restrictionTime = 0
        percentProgress = 0
        restrictions = nil
    }
}
