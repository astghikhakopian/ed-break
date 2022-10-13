//
//  ChildProfileModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 13.10.22.
//

struct ChildProfileModel {
    
    let educationPeriod: TimePeriod
    let activityPeriod: TimePeriod
    let childId: Int
    let periodAnswers: Int
    let periodCorrectAnswers: Int
    let percentageForPeriod: Float
    let lastLogin: String
    let periodActivity: Float
    let averageActivity: Float
    
    init(dto: ChildRetriveDto) {
        educationPeriod = TimePeriod(rawValue: dto.educationPeriod) ?? .day
        activityPeriod = TimePeriod(rawValue: dto.activityPeriod) ?? .day
        childId = dto.childId
        periodAnswers = dto.periodAnswers
        periodCorrectAnswers = dto.periodCorrectAnswers
        percentageForPeriod = dto.percentageForPeriod
        lastLogin = dto.lastLogin ?? ""
        periodActivity = Float(Int(dto.periodActivity*10))/10
        averageActivity = Float(Int(dto.averageActivity*10))/10 
    }
    
    init(childId: Int) {
        educationPeriod = TimePeriod.day
        activityPeriod = TimePeriod.day
        self.childId = childId
        periodAnswers = 0
        periodCorrectAnswers = 0
        percentageForPeriod = 0
        lastLogin = ""
        periodActivity = 0
        averageActivity = 0
    }
}
