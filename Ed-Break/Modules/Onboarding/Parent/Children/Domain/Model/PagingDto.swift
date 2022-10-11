//
//  PagingDto.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 04.10.22.
//

struct PagingDto<R: Codable>: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [R]
}

struct ChildDto: Codable {
    let id: Int
    let name: String
    let grade: Int
    let restrictionTime: Int?
    let photo: String?
    let todayAnswers: Int?
    let todayCorrectAnswers: Int?
    let percentageToday: Float?
    let lastLogin: String?
}
