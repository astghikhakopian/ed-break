//
//  HomeModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 08.11.22.
//

import Foundation

struct HomeModel {
    
    let childId: Int
    let lastLogin: Date?
    let restrictionTime: Int
    let subjects: [SubjectModel]
    
    init(dto: HomeDto) {
        childId = dto.childId
        lastLogin = Date(fromString: dto.lastLogin ?? "", format: .isoDateTime)
        restrictionTime = dto.restrictionTime
        subjects = dto.subjects.map { SubjectModel(dto: $0) }
    }
}

struct SubjectModel {
    let id: Int
    let title: String?
    let photo: String?
    let questionsCount: Int
    let completedCount: Int
    let correctAnswersCount: Int
    let completed: Bool
    
    init(dto: SubjectDto) {
        id = dto.id
        title = dto.title
        photo = dto.photo
        questionsCount = dto.questionsCount
        completedCount = dto.completedCount
        correctAnswersCount = dto.correctAnswersCount
        completed = dto.completed
    }
}

