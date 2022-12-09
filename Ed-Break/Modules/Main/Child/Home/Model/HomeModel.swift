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
    let restrictionTime: Date?
    let restrictions: FamilyActivitySelection?
    var interruption: Int?
    var breakEndDatetime: Date?
    var breakStartDatetime: Date?
    let subjects: [SubjectModel]
    var wrongAnswersTime: Date?
    let deviceToken: String?
    
    init(dto: HomeDto) {
        childId = dto.childId
        deviceToken = dto.deviceToken
        lastLogin = Date(fromString: dto.lastLogin ?? "", format: .isoDateTimeFull)
        restrictionTime = Date(fromString: dto.restrictions ?? "", format: .isoDateTimeFull)
        breakStartDatetime = Date(fromString: dto.breakStartDatetime ?? "", format: .isoDateTimeFull)
        breakEndDatetime = Date(fromString: dto.breakEndDatetime ?? "", format: .isoDateTimeFull)
        wrongAnswersTime = Date(fromString: dto.wrongAnswersTime ?? "", format: .isoDateTimeFull)
        interruption = dto.interruption
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

struct SubjectModel: BottomsheetCellModel, Equatable {
    var title: String { subject ?? "" }
    var imageUrl: URL? { photo == nil ? nil : URL(string: photo!) }
    
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
        questionsCount = dto.questionsCount ?? 0
        completedCount = dto.completedCount ?? 0
        correctAnswersCount = dto.correctAnswersCount ?? 0
        completed = dto.completed ?? false
    }

    init(dto: CoachingSubjectDto) {
        id = dto.id
        subject = dto.title
        photo = dto.photo
        questionsCount = dto.questionsCount ?? 0
        completedCount = dto.answersCount ?? 0
        correctAnswersCount = dto.correctAnswersCount ?? 0
        completed = completedCount >= questionsCount
    }
    
    init() {
        self.id = 0
        self.subject = nil
        self.photo = nil
        self.questionsCount = 0
        self.completedCount = 0
        self.correctAnswersCount = 0
        self.completed = false
    }
}
