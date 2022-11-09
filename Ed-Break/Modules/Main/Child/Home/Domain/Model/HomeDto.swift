//
//  HomeDto.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 08.11.22.
//

import Foundation

struct HomeDto: Codable {
    let childId: Int
    let lastLogin: String?
    let restrictionTime: Int
    let subjects: [SubjectDto]
}

struct SubjectDto: Codable {
    let id: Int
    let title: String?
    let photo: String?
    let questionsCount: Int
    let completedCount: Int
    let correctAnswersCount: Int
    let completed: Bool
}
