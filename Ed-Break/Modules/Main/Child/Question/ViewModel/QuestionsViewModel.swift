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
    @Published var isFeedbackGiven: Bool? = false
    @Published var remindingSeconds: Int = 0 {
        didSet {
            guard remindingSeconds >= 0 else { buttonTitle = "common.continue"; return }
                if remindingSeconds == 0 {
                    buttonTitle = "Additional Questions"
                    isContentValid = true
                } else {
                    let seconds = (remindingSeconds % 3600) % 60
                    let minutes = ((remindingSeconds % 3600) / 60)
                    let secondsString = seconds <= 9 ? "0\(seconds)" : "\(seconds)"
                    let minutesString = minutes <= 9 ? "0\(minutes)" : "\(minutes)"
                    buttonTitle = "\(minutes):\(secondsString)"
                    //"0:\(remindingSeconds <= 9 ? "0\(remindingSeconds)" : "\(remindingSeconds)")"
                    isContentValid = false
                }
        }
    }
    
    @Published var buttonTitle: String = "common.continue"
    @Published var isContentValid: Bool = false
   
    let subject: SubjectModel
    let home: HomeModel?
    private let getQuestionsUseCase: GetQuestionsUseCase
    private let answerQuestionUseCase: AnswerQuestionUseCase
    private let resultOfAdditionalQuestionsUseCase: ResultOfAdditionalQuestionsUseCase
    
    var textToSpeachManager: TextToSpeachManager
    
    init(subject: SubjectModel, home: HomeModel?, getQuestionsUseCase: GetQuestionsUseCase, answerQuestionUseCase: AnswerQuestionUseCase, resultOfAdditionalQuestionsUseCase: ResultOfAdditionalQuestionsUseCase, textToSpeachManager: TextToSpeachManager) {
        self.subject = subject
        self.home = home
        self.getQuestionsUseCase = getQuestionsUseCase
        self.answerQuestionUseCase = answerQuestionUseCase
        self.resultOfAdditionalQuestionsUseCase = resultOfAdditionalQuestionsUseCase
        self.textToSpeachManager = textToSpeachManager
    }
    
    func getQuestions() {
        isLoading = true
        getQuestionsUseCase.execute(subjectId: subject.id) { result in
            DispatchQueue.main.async { self.isLoading = false }
            switch result {
            case .success(let model):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.questionsContainer = model
                    if let wrongAnswersTime = self.home?.wrongAnswersTime,
                       let difference = self.getSeconds(start: wrongAnswersTime),
                        difference < 0 {
                        self.remindingSeconds = -difference
                    }
                    if model.answeredCount < model.questions.count {
                        self.currentQuestion = model.questions[model.answeredCount]
                    } else {
                        // self.remindingMinutes = 0
                    }
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func getAdditionalQuestions() {
        isLoading = true
        getQuestionsUseCase.execute { result in
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
        answerQuestionUseCase.execute(questionId: currentQuestion.id, answerId: answer.id) { [weak self] result in
            DispatchQueue.main.async { self?.isLoading = false }
            guard result == nil else { return }
            // switch result {
            // case .success:
            
            guard let self = self, let questionsContainer = self.questionsContainer else { return }
            let answersCount = questionsContainer.answeredCount
            if answersCount + 1 < questionsContainer.questions.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                    guard let self = self, let questionsContainer = self.questionsContainer, answersCount + 1 < self.questionsContainer?.questions.count ?? 0 else { return }
                    self.questionsContainer?.answeredCount = answersCount + 1
                    self.questionsContainer?.questions[answersCount].isCorrect = answer.correct
                    self.currentQuestion = questionsContainer.questions[answersCount + 1]
                    self.isFeedbackGiven = false
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.isFeedbackGiven = false
                    completion(answer.correct ? .success : .failure)
                }
            }
            DispatchQueue.main.async { [weak self] in
                self?.answerResultType = answer.correct ? .success : .failure
            }
            
                
            
//                }
//            case .failure(let failure):
//                print(failure.localizedDescription)
//            }
        }
    }
    
    func didAnswerAdditionalQuestions(completion: @escaping ()->()) {
        isLoading = true
        resultOfAdditionalQuestionsUseCase.execute { result in
            DispatchQueue.main.async { self.isLoading = false }
            guard result == nil else { return }
            completion()
        }
    }
    
    private func getSeconds(start: Date?) -> Int? {
        guard let start = start else { return nil }
        let diff = Int(Date().toLocalTime().timeIntervalSince1970 - start.timeIntervalSince1970)
        
        let hours = diff / 3600
        let minutes = (diff - hours * 3600)
        return minutes
    }
}


// MARK: - Preview

final class MockQuestionsViewModel: QuestionsViewModeling, Identifiable {
    var textToSpeachManager: TextToSpeachManager = DefaultTextToSpeachManager()
    
    var isFeedbackGiven: Bool? = false
    
    
    var questionsContainer: QuestionsContainerModel? = QuestionsContainerModel(
        dto: QuestionsContainerDto(
            questions: [
                QusetionDto(
                    id: 0,
                    questionAnswer: [
                        QuestionAnswerDto(id: 0, answer: "ban che", correct: true, question: 1),
                        QuestionAnswerDto(id: 1, answer: "ban che 1", correct: false, question: 2)
                    ],
                    questionText: "Inch ka",
                    isCorrect: nil,
                    subject: SubjectDto(
                        id: 0,
                        subject: "Math",
                        photo: "https://ed-break-back-dev.s3.amazonaws.com/media/800px-Stylised_atom_with_three_Bohr_model_orbits_and_stylised_nucleus.svg.png",
                        questionsCount: 1,
                        completedCount: 0,
                        correctAnswersCount: 0,
                        completed: false))],
            answeredCount: 0))
    var currentQuestion: QusetionModel = QusetionModel(dto: QusetionDto(
        id: 0,
        questionAnswer: [
            QuestionAnswerDto(id: 0, answer: "ban che", correct: true, question: 1),
            QuestionAnswerDto(id: 1, answer: "ban che 1", correct: false, question: 2),
            QuestionAnswerDto(id: 2, answer: "ban che 2", correct: false, question: 3),
            QuestionAnswerDto(id: 3, answer: "ban che 3", correct: false, question: 4)
        ],
        questionText: "Inch ka, vonts ek,vonts chek?. Vaghuts cheink tesnvel. u sents yerkar text",
        isCorrect: nil,
        subject: SubjectDto(
            id: 0,
            subject: "Math",
            photo: "https://ed-break-back-dev.s3.amazonaws.com/media/800px-Stylised_atom_with_three_Bohr_model_orbits_and_stylised_nucleus.svg.png",
            questionsCount: 1,
            completedCount: 0,
            correctAnswersCount: 0,
            completed: false)))
    var subject: SubjectModel = SubjectModel(dto: SubjectDto(id: 0, subject: "Math", photo: nil, questionsCount: 0, completedCount: 0, correctAnswersCount: 0, completed: true))
    var isLoading = false
    var answerResultType: AnswerResultType? = nil
    var remindingSeconds = 0
    var buttonTitle: String = ""
    var isContentValid: Bool = false
    
    func getQuestions() { }
    func getAdditionalQuestions() { }
    func answerQuestion(answer: QuestionAnswerModel, completion: @escaping (AnswerResultType)->()) { }
    func didAnswerAdditionalQuestions(completion: @escaping ()->()) { }
}
