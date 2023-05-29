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
    var currentQuestion: QusetionModel { get set }
    var remindingSeconds: Int { get set }
    var buttonTitle: String { get set }
    var isContentValid: Bool { get set }
    var subject: SubjectModel { get }
    var isFeedbackGiven: Bool? { get set }
    var textToSpeachManager: TextToSpeachManager { get set }
    var areSubjectQustionsAnswered: Bool { get }
    var isPhoneUnlocked: Bool { get }
    
    func getQuestions()
    func getAdditionalQuestions(complition: @escaping ()->())
    func answerQuestion(answer: QuestionAnswerModel, isAdditionalQuestions: Bool, completion: @escaping (AnswerResultType)->())
    func didAnswerAdditionalQuestions(completion: @escaping ()->())
}
