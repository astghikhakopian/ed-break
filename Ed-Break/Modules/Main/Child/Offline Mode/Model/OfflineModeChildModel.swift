//
//  OfflineModeChildModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 03.08.23.
//

import Foundation
import FamilyControls

struct OfflineChildModel {
    
    let id: Int
    let name: String
    let restrictionTime: Int?
    var breakStartDatetime: String?
    var wrongAnswersTime: String?
    var breakStartDate: Date? {
        Date(fromString: breakStartDatetime ?? "", format: .isoDateTimeFull)?.toLocalTime()
    }
    var wrongAnswersDate: Date? {
        Date(fromString: wrongAnswersTime ?? "", format: .isoDateTimeFull)?.toLocalTime()
    }
    let restrictions: String?
    var restrictionsObject: FamilyActivitySelection? {
        if let restrictions = restrictions?.replacingOccurrences(of: "\\\"", with: "\""),
           let stringData = restrictions.data(using: .utf8),
           let selectionObject = try? JSONDecoder().decode(FamilyActivitySelection.self, from: stringData) {
            return selectionObject
        } else {
            return nil
        }
    }
    let interruption: Int?
    let childSubjects: [OfflineSubjectModel]
    
    init(dto: OfflineChildDto) {
        id = dto.id
        name = dto.name ?? ""
        restrictionTime = dto.restrictionTime
        breakStartDatetime = dto.breakStartDatetime
        wrongAnswersTime = dto.wrongAnswersTime
        restrictions = dto.restrictions
        interruption = dto.interruption
        childSubjects = (dto.childSubjects ?? []).map { OfflineSubjectModel(dto: $0) }
    }
    
    init(mo: OfflineChildMO) {
        id = Int(mo.id)
        name = mo.name ?? ""
        restrictionTime = mo.restrictionTime == -1 ? nil : Int(mo.restrictionTime)
        breakStartDatetime = mo.breakStartDatetime
        wrongAnswersTime = mo.wrongAnswersTime
        restrictions = mo.restrictions
        interruption = mo.interruption == -1 ? nil : Int(mo.interruption)
        childSubjects = Array(_immutableCocoaArray: mo.childSubjects ?? []).map { OfflineSubjectModel(mo: $0) }
    }
}

struct OfflineSubjectModel {
    
    let id: Int
    let subject: String?
    let photo: String?
    let questions: [OfflineQusetionModel]
    
    init(dto: OfflineSubjectDto) {
        id = dto.id
        subject = dto.subject
        photo = dto.photo
        questions = (dto.questions ?? []).map { OfflineQusetionModel(dto: $0) }
    }
    
    init(mo: OfflineSubjectMO) {
        id = Int(mo.id)
        subject = mo.subject
        photo = mo.photo
        questions = Array(_immutableCocoaArray: mo.questions ?? []).map { OfflineQusetionModel(mo: $0) }
    }
    
    init() {
        id = -1
        subject = ""
        photo = ""
        questions = []
    }
}


struct OfflineQusetionModel {
    
    let id: Int
    let questionText: String
    let answers: [OfflineQuestionAnswerModel]
    let grade: [Int]
    var isCorrect = false
    
    init(dto: OfflineQusetionDto) {
        id = dto.id
        questionText = dto.questionText ?? ""
        answers = (dto.answers ?? []).map { OfflineQuestionAnswerModel(dto: $0) }
        grade = dto.grade ?? []
    }
    
    init(mo: OfflineQusetionMO) {
        id = Int(mo.id)
        questionText = mo.questionText ?? ""
        answers = Array(_immutableCocoaArray: mo.answers ?? []).map { OfflineQuestionAnswerModel(mo: $0) }
        grade = []
    }
}

struct OfflineQuestionAnswerModel {
    
    let id: Int
    let answer: String
    let correct: Bool
    
    init(dto: OfflineQuestionAnswerDto) {
        id = dto.id
        answer = dto.answer ?? ""
        correct = dto.correct ?? false
    }
    
    init(mo: OfflineQuestionAnswerMO) {
        id = Int(mo.id)
        answer = mo.answer ?? ""
        correct = mo.correct
    }
}

struct OfflineQuestionsContainerModel {
    
    var questionGroupType: QuestionType
    var questions: [OfflineQusetionModel]
    var questionsCount: Int
    var answeredQuestionsCount: Int
    var correctAnswersCount: Int
    var wrongAnswersTime: Date?
    var isCorrect: Bool?
}
