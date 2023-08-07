//
//  OfflineChildDto.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 03.08.23.
//

import Foundation

struct OfflineChildDto: Codable {
    
    let id: Int
    let name: String?
    let restrictionTime: Int?
    let breakStartDatetime: String?
    let wrongAnswersTime: String?
    let restrictions: String?
    let interruption: Int?
    let childSubjects: [OfflineSubjectDto]?
}

struct OfflineSubjectDto: Codable {
    
    let id: Int
    let subject: String?
    let photo: String?
    let questions: [OfflineQusetionDto]?
}


struct OfflineQusetionDto: Codable {
    
    let id: Int
    let questionText: String?
    let answers: [OfflineQuestionAnswerDto]?
    let grade: [Int]?
}

struct OfflineQuestionAnswerDto: Codable {
    
    let id: Int
    let answer: String?
    let correct: Bool?
}
