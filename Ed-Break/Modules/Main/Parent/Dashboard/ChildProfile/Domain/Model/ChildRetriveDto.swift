//
//  ChildRetriveDto.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 11.10.22.
//

struct ChildRetriveDto: Codable {
    
    let educationPeriod: String
    let activityPeriod: String
    let childId: Int
    let periodAnswers: Int
    let periodCorrectAnswers: Int
    let lastLogin: String?
    let periodActivity: Float
    let averageActivity: Float
    let percentagesOfCorrectAnswers: Float?
    let percentProgress: Int?
    let restrictionTime: Int?
    let restrictions: String?
    let interruption: Int?
}
