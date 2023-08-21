//
//  OfflineChildQuestionViewModeling.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 16.08.23.
//

import SwiftUI

protocol OfflineChildQuestionViewModeling: ObservableObject {
    
    var questionsContainer: OfflineQuestionsContainerModel? { get set }
    var currentQuestion: OfflineQusetionModel? { get set }
    var answerResultType: AnswerResultType? { get set }
    var isContentValid: Bool { get set }
    var subject: OfflineSubjectModel? { get }
    var isFeedbackGiven: Bool { get set }
    var areSubjectQustionsAnswered: Bool { get }
    var isPhoneUnlocked: Bool { get }
    var isLastQuestion: Bool { get set }
    
    var isLoading: Bool { get set }
    
    func getQuestions()
    func answerQuestion(
        answer: OfflineQuestionAnswerModel,
        completion: @escaping (AnswerResultType)->()
    ) 
}
