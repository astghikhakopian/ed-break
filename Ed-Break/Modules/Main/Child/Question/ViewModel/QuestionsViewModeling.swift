//
//  QuestionsViewModeling.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 15.11.22.
//

import SwiftUI

protocol QuestionsViewModeling: ObservableObject, Identifiable {
    
    var isLoading: Bool { get set }
    var answerResultType: AnswerResultType? { get set }
    var questionsContainer: QuestionsContainerModel? { get set }
    var currentReadingItem: QuestionsViewModel.CurrentReadingItem? { get set }
    var currentQuestion: QusetionModel { get set }
    var isContentValid: Bool { get set }
    var subject: SubjectModel { get }
    var isFeedbackGiven: Bool { get set }
    var areSubjectQustionsAnswered: Bool { get }
    var isPhoneUnlocked: Bool { get }
    var isLastQuestion: Bool { get set }
    
    func getQuestions()
    func answerQuestion(answer: QuestionAnswerModel, isAdditionalQuestions: Bool, completion: @escaping (AnswerResultType)->())
    
    func startPlayingQuestion()
    func stopPlayingQuestion()
}
