//
//  QuestionsContainerDto.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 19.11.22.
//

import Foundation

struct QuestionsContainerDto: Codable {

    let questions: [QusetionDto]?
    let answeredCount: Int
}

struct QusetionDto: Codable {
    
    let id: Int
    let questionAnswer: [QuestionAnswerDto]?
    let questionText: String?
    let subject: SubjectDto?
}

struct QuestionAnswerDto: Codable {
    
    let id: Int
    let answer: String?
    let correct: Bool?
    let question: Int?
}
