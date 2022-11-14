//
//  HomeModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 08.11.22.
//

import Foundation
import FamilyControls

struct HomeModel {
    
    let childId: Int
    let lastLogin: Date?
    let restrictionTime: Int
    let restrictions: FamilyActivitySelection?
    let subjects: [SubjectModel]
    
    init(dto: HomeDto) {
        childId = dto.childId
        lastLogin = Date(fromString: dto.lastLogin ?? "", format: .isoDateTime)
        restrictionTime = dto.restrictionTime
        subjects = dto.subjects.map { SubjectModel(dto: $0) }
        
        if let restrictions = dto.restrictions?.replacingOccurrences(of: "\\\"", with: "\""),
           let stringData = restrictions.data(using: .utf8),
           // let json = try? JSONSerialization.jsonObject(with: stringData),
           let selectionObject = try? JSONDecoder().decode(FamilyActivitySelection.self, from: stringData) {
            self.restrictions = selectionObject
        } else {
            restrictions = nil
        }
    }
}

struct SubjectModel {
    let id: Int
    let subject: String?
    let photo: String?
    let questionsCount: Int
    let completedCount: Int
    let correctAnswersCount: Int
    let completed: Bool
    
    init(dto: SubjectDto) {
        id = dto.id
        subject = dto.subject
        photo = dto.photo
        questionsCount = dto.questionsCount
        completedCount = dto.completedCount
        correctAnswersCount = dto.correctAnswersCount
        completed = dto.completed
    }
}

