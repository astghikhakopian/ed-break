//
//  QuestionModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 14.11.22.
//

struct QuestionsContainerModel {
    
    var questions: [QusetionModel]
    var answeredCount: Int
    var isCorrect: Bool?
    
    init(dto: QuestionsContainerDto) {
        questions = dto.questions?.map { QusetionModel(dto: $0) } ?? []
        answeredCount = dto.answeredCount ?? 0
        isCorrect = dto.isCorrect
    }
}

struct QusetionModel: Equatable {
    
    let id: Int
    var isCorrect: Bool?
    let questionAnswer: [QuestionAnswerModel]
    let questionText: String?
    let subject: SubjectModel?
    
    init(dto: QusetionDto) {
        id = dto.id
        isCorrect = dto.isCorrect
        questionAnswer = dto.questionAnswer?.map { QuestionAnswerModel(dto: $0) } ?? []
        questionText = dto.questionText
        subject = dto.subject == nil ? nil : SubjectModel(dto: dto.subject!)
    }
    
    init() {
        id = 0
        questionAnswer = []
        questionText = nil
        subject = nil
    }
    static func == (lhs: QusetionModel, rhs: QusetionModel) -> Bool {
        return lhs.id == rhs.id
    }
}

struct QuestionAnswerModel {
    
    let id: Int
    let answer: String?
    let correct: Bool
    let question: Int?
    
    init(dto: QuestionAnswerDto) {
        id = dto.id
        answer = dto.answer
        correct = dto.correct ?? false
        question = dto.question
    }
}
