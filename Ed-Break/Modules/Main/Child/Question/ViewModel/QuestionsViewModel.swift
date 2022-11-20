//
//  QuestionsViewModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 15.11.22.
//

import UIKit

final class QuestionsViewModel: QuestionsViewModeling, Identifiable {
    
    @Published var questionsContainer: QuestionsContainerModel?
    @Published var currentQuestion: QusetionModel = QusetionModel()
    @Published var isLoading: Bool = false
    @Published var answerResultType: AnswerResultType? = nil
   
    let subject: SubjectModel
    private let getQuestionsUseCase: GetQuestionsUseCase
    private let answerQuestionUseCase: AnswerQuestionUseCase
    
    init(subject: SubjectModel, getQuestionsUseCase: GetQuestionsUseCase, answerQuestionUseCase: AnswerQuestionUseCase) {
        self.subject = subject
        self.getQuestionsUseCase = getQuestionsUseCase
        self.answerQuestionUseCase = answerQuestionUseCase
        
    }
    
    func getQuestions() {
        isLoading = true
        getQuestionsUseCase.execute(subjectId: subject.id) { result in
            DispatchQueue.main.async { self.isLoading = false }
            switch result {
            case .success(let model):
                DispatchQueue.main.async { [weak self] in
                    self?.questionsContainer = model
                    if model.answeredCount < model.questions.count {
                        self?.currentQuestion = model.questions[model.answeredCount]
                    }
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func answerQuestion(answer: QuestionAnswerModel, completion: @escaping (AnswerResultType)->()) {
        isLoading = true
        answerQuestionUseCase.execute(questionId: currentQuestion.id, answerId: answer.id) { result in
            DispatchQueue.main.async { self.isLoading = false }
            guard result == nil else { return }
            // switch result {
            // case .success:
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) { [weak self] in
                    guard let self = self, let questionsContainer = self.questionsContainer else { return }
                    let answersCount = questionsContainer.answeredCount
                    if answersCount + 1 < questionsContainer.questions.count {
                        self.questionsContainer?.answeredCount = answersCount + 1
                        self.currentQuestion = questionsContainer.questions[answersCount + 1]
                    } else {
                        completion(answer.correct ? .success : .failure)
                    }
                    self.answerResultType = answer.correct ? .success : .failure
                }
//            case .failure(let failure):
//                print(failure.localizedDescription)
//            }
        }
    }
}


// MARK: - Preview

final class MockQuestionsViewModeling: QuestionsViewModeling, Identifiable {
    
    var questionsContainer: QuestionsContainerModel?
    var currentQuestion: QusetionModel = QusetionModel()
    var subject: SubjectModel = SubjectModel(dto: SubjectDto(id: 0, subject: "Math", photo: nil, questionsCount: 0, completedCount: 0, correctAnswersCount: 0, completed: true))
    var isLoading = false
    var answerResultType: AnswerResultType? = nil
    
    func getQuestions() { }
    func answerQuestion(answer: QuestionAnswerModel, completion: @escaping (AnswerResultType)->()) { }
}
