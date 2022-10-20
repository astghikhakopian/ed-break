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
  let percentageForPeriod: Float?
  let lastLogin: String?
  let periodActivity: Float
  let averageActivity: Float
}
