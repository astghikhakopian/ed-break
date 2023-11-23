//
//  QuestionModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 14.11.22.
//

import Foundation

struct QuestionsContainerModel {
    
    var questionGroupType: QuestionType
    var questions: [QusetionModel]
    var questionsCount: Int
    var answeredQuestionsCount: Int
    let correctAnswersCount: Int
    var wrongAnswersTime: Date?
    var isCorrect: Bool?
    
    init(dto: QuestionsContainerDto) {
        questionGroupType = QuestionType(rawValue: dto.questionGroupType ?? "") ?? .main
        questions = dto.questions?.map { QusetionModel(dto: $0) } ?? []
        questionsCount = dto.questionsCount ?? 0
        answeredQuestionsCount = dto.answeredQuestionsCount ?? 0
        correctAnswersCount = dto.correctAnswersCount ?? 0
        wrongAnswersTime = Date(fromString: dto.wrongAnswersTime ?? "", format: .isoDateTimeFull)?.toLocalTime()
        isCorrect = dto.isCorrect
    }
    
    init(offlineModel: QuestionsContainerDto) {
        questionGroupType = QuestionType(rawValue: offlineModel.questionGroupType ?? "") ?? .main
        questions = offlineModel.questions?.map { QusetionModel(dto: $0) } ?? []
        questionsCount = offlineModel.questionsCount ?? 0
        answeredQuestionsCount = offlineModel.answeredQuestionsCount ?? 0
        correctAnswersCount = offlineModel.correctAnswersCount ?? 0
        wrongAnswersTime = Date(fromString: offlineModel.wrongAnswersTime ?? "", format: .isoDateTimeFull)?.toLocalTime()
        isCorrect = offlineModel.isCorrect
    }
}

struct QusetionModel: Equatable {
    
    let uuid = UUID()
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
    
    init(offlineQusetionModel: OfflineQusetionModel) {
        id = offlineQusetionModel.id
        isCorrect = offlineQusetionModel.isCorrect
        questionAnswer = offlineQusetionModel.answers.map { QuestionAnswerModel(offlineQuestionAnswerModel: $0) }
        questionText = offlineQusetionModel.questionText
        subject = nil
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

struct QuestionAnswerModel: Equatable {
    
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
    
    init(offlineQuestionAnswerModel: OfflineQuestionAnswerModel) {
        id = offlineQuestionAnswerModel.id
        answer = offlineQuestionAnswerModel.answer
        correct = offlineQuestionAnswerModel.correct
        question = nil
    }
}

struct QuestionResultModel: Codable {
    
    let correct: Bool
    
    init(dto: QuestionResultDto) {
        correct = dto.correct
    }
}
