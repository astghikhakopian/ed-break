//
//  OfflineChildQuestionViewModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 16.08.23.
//

import UIKit
import CoreData
import Combine

final class OfflineChildQuestionViewModel: OfflineChildQuestionViewModeling {
    
    @Published var questionsContainer: OfflineQuestionsContainerModel?
    @Published var currentQuestion: OfflineQusetionModel?
    @Published var answerResultType: AnswerResultType? = nil
    @Published var isFeedbackGiven: Bool = false
    @Published var isLastQuestion: Bool = false
    @Published var isContentValid: Bool = false
    @Published var isLoading: Bool = false
    
    var areSubjectQustionsAnswered: Bool {
        guard let questionsContainer = questionsContainer else { return false }
        return questionsContainer.answeredQuestionsCount >= questionsContainer.questions.count
    }
    var isPhoneUnlocked: Bool {
        DataModel.shared.isDiscourageEmpty
    }
    
    let subject: OfflineSubjectModel?
    let contentModel: OfflineChildModel?
    
    private let updateAnsweredQuestionOfflineChildUseCase: UpdateAnsweredQuestionOfflineChildUseCase
    private let context: NSManagedObjectContext
    
    private var cancelables = Set<AnyCancellable>()
    
    private let mainQuestionsCount = 5
    
    init(
        subject: OfflineSubjectModel?,
        contentModel: OfflineChildModel?,
        updateAnsweredQuestionOfflineChildUseCase: UpdateAnsweredQuestionOfflineChildUseCase,
        context: NSManagedObjectContext
    ) {
        self.subject = subject
        self.contentModel = contentModel
        self.updateAnsweredQuestionOfflineChildUseCase = updateAnsweredQuestionOfflineChildUseCase
        self.context = context
    }
    
    
    func getQuestions() {
        guard let subject = subject,
              subject.questions.count >= mainQuestionsCount
        else { return }
        
        let randomQuestions = Array(subject.questions.shuffled().prefix(mainQuestionsCount))
        let questionsContainer = OfflineQuestionsContainerModel(
            questionGroupType: .main,
            questions: randomQuestions,
            questionsCount: mainQuestionsCount,
            answeredQuestionsCount: 0,
            correctAnswersCount: 0
        )
              
        self.questionsContainer = questionsContainer
        self.currentQuestion = questionsContainer.questions[0]
        self.isLastQuestion = isTheLastQuestion
    }
    
    func answerQuestion(
        answer: OfflineQuestionAnswerModel,
        completion: @escaping (AnswerResultType)->()
    ) {
        guard let questionsContainer = questionsContainer else { return }
        let answersCount = questionsContainer.answeredQuestionsCount
        let correctAnswersCount = self.questionsContainer?.correctAnswersCount ?? 0
        self.questionsContainer?.correctAnswersCount = answer.correct ? correctAnswersCount + 1 : correctAnswersCount
        if answersCount + 1 < questionsContainer.questions.count {
          guard
              let questionsContainer = self.questionsContainer,
              answersCount + 1 < self.questionsContainer?.questions.count ?? 0
          else { return }
          self.questionsContainer?.answeredQuestionsCount = answersCount + 1
            self.questionsContainer?.questions[answersCount].isCorrect = answer.correct
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
              
              guard let self = self else { return  }
                
                self.currentQuestion = questionsContainer.questions[answersCount + 1]
                self.isLastQuestion = isTheLastQuestion
                self.isFeedbackGiven = false
                self.isContentValid = false
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.isFeedbackGiven = false
                if self.isTheLastQuestion {
                    self.updateFullAnswerResult()
                }
                completion(answer.correct ? .success : .failure)
            }
        }
        DispatchQueue.main.async { [weak self] in
            self?.answerResultType = answer.correct ? .success : .failure
        }
        completion(.success)
    }
    
    private var isTheLastQuestion: Bool {
        guard let currentQuestion = currentQuestion else { return false }
        let currentQuestionIndex = questionsContainer?.questions.firstIndex(
            where: { $0.id == currentQuestion.id }
        ) ?? 0
        return questionsContainer?.questions.count ?? 1 == currentQuestionIndex + 1
    }
    
    private func updateFullAnswerResult() {
        guard let correctAnswersCount = questionsContainer?.correctAnswersCount else { return }
        let shouldRestrict = mainQuestionsCount > correctAnswersCount * 2
        
        updateBreakTime(shouldRestrict: shouldRestrict)
        updateWrongAnswersTime(shouldRestrict: shouldRestrict)
    }
    
    private func updateBreakTime(shouldRestrict: Bool) {
        guard var model = contentModel else { return }
        let date = shouldRestrict ? nil : Date()
        model.breakStartDatetime = date?.toGMTTime().toString(format: .custom("yyyy-MM-dd'T'HH:mm:ss.SSSZ"))
        updateAnsweredQuestionOfflineChildUseCase.execute(model: model, in: context)
            .sink { result in
                switch result {
                case .finished: break
                case .failure: break
                }
            } receiveValue: { success in
                print(success)
            }.store(in: &cancelables)
    }
    
    private func updateWrongAnswersTime(shouldRestrict: Bool) {
        guard shouldRestrict,
              var model = contentModel else { return }
        
      let date = Calendar.current.date(byAdding: .minute, value: 5, to: Date().toGMTTime())
        model.wrongAnswersTime = date?.toLocal().toString(format: .custom("yyyy-MM-dd'T'HH:mm:ss.SSSZ"))
        
        updateAnsweredQuestionOfflineChildUseCase.execute(model: model, in: context)
            .sink { result in
                switch result {
                case .finished: break
                case .failure: break
                }
            } receiveValue: { success in
                print(success)
            }.store(in: &cancelables)
    }
}


// MARK: - Preview

final class MockOfflineChildQuestionViewModel: OfflineChildQuestionViewModeling {
    var questionsContainer: OfflineQuestionsContainerModel? = nil
    var currentQuestion: OfflineQusetionModel? = nil
    var subject: OfflineSubjectModel? = nil
    
    var areSubjectQustionsAnswered: Bool = false
    var isPhoneUnlocked: Bool = false
    var isFeedbackGiven: Bool = false
    
    var isLoading = false
    var answerResultType: AnswerResultType? = nil
    var isContentValid: Bool = false
    var isLastQuestion: Bool = false
    
    func getQuestions() { }
    func answerQuestion(answer: OfflineQuestionAnswerModel, completion: @escaping (AnswerResultType) -> ()) { }
}

