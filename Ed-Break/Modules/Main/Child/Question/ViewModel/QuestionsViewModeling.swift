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
    var remindingMinutes: Int { get set }
    var buttonTitle: String { get set }
    var isContentValid: Bool { get set }
    var subject: SubjectModel { get }
    
    func getQuestions()
    func getAdditionalQuestions()
    func answerQuestion(answer: QuestionAnswerModel, completion: @escaping (AnswerResultType)->())
    func didAnswerAdditionalQuestions(completion: @escaping ()->())
}
