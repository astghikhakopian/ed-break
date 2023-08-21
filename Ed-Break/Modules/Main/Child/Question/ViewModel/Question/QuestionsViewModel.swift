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
    @Published var isFeedbackGiven: Bool = false
    @Published var isLastQuestion: Bool = false
    @Published var isContentValid: Bool = false
    
    var areSubjectQustionsAnswered: Bool {
        guard let questionsContainer = questionsContainer else { return false }
        return questionsContainer.answeredQuestionsCount >= questionsContainer.questions.count
    }
    var isPhoneUnlocked: Bool {
        DataModel.shared.isDiscourageEmpty
    }
    
    let subject: SubjectModel
    let home: HomeModel?
    private let getQuestionsUseCase: GetQuestionsUseCase
    private let answerQuestionUseCase: AnswerQuestionUseCase
    
    init(
        subject: SubjectModel,
        home: HomeModel?,
        getQuestionsUseCase: GetQuestionsUseCase,
        answerQuestionUseCase: AnswerQuestionUseCase
    ) {
        self.subject = subject
        self.home = home
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
                    guard let self = self else { return }
                    self.questionsContainer = model
                    
                    guard !model.questions.isEmpty else { return }
                    if model.answeredQuestionsCount < model.questions.count {
                        self.currentQuestion = model.questions[model.answeredQuestionsCount]
                        self.isLastQuestion = isTheLastQuestion
                    } else {
                        self.currentQuestion = model.questions[0]
                        self.isLastQuestion = isTheLastQuestion
                    }
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func answerQuestion(answer: QuestionAnswerModel, isAdditionalQuestions: Bool, completion: @escaping (AnswerResultType)->()) {
        isLoading = true
        
        let index = questionsContainer?.questions.firstIndex(of: currentQuestion) ?? 0
        answerQuestionUseCase.execute(
            answerId: answer.id,
            index: index,
            questionType: questionsContainer?.questionGroupType ?? .main
        ) { [weak self] result in
            DispatchQueue.main.async { self?.isLoading = false }
            switch result {
            case .success(let result):
                guard let self = self, let questionsContainer = self.questionsContainer else { return }
                let answersCount = questionsContainer.answeredQuestionsCount
                if answersCount + 1 < questionsContainer.questions.count {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                        guard
                            let self = self,
                            let questionsContainer = self.questionsContainer,
                            answersCount + 1 < self.questionsContainer?.questions.count ?? 0
                        else { return }
                        self.questionsContainer?.answeredQuestionsCount = answersCount + 1
                        self.questionsContainer?.questions[answersCount].isCorrect = result.correct
                        self.currentQuestion = questionsContainer.questions[answersCount + 1]
                        self.isLastQuestion = isTheLastQuestion
                        self.isFeedbackGiven = false
                        self.isContentValid = false
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
                completion(.success)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    private var isTheLastQuestion: Bool {
        let currentQuestionIndex = questionsContainer?.questions.firstIndex(of: currentQuestion) ?? 0
        return (questionsContainer?.questions.count ?? 1) - 1 == currentQuestionIndex
    }
}


// MARK: - Preview

final class MockQuestionsViewModel: QuestionsViewModeling {
    
    var areSubjectQustionsAnswered: Bool = false
    var isPhoneUnlocked: Bool = false
    var isFeedbackGiven: Bool = false
    
    var questionsContainer: QuestionsContainerModel? = QuestionsContainerModel(
        dto: QuestionsContainerDto(
            questionGroupType: "main",
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
                        answeredQuestionsCount: 0,
                        correctAnswersCount: 0,
                        completed: false))],
            questionsCount: 1,
            wrongAnswersTime: nil,
            answeredQuestionsCount: 9,
            correctAnswersCount: 0
        )
    )
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
            answeredQuestionsCount: 0,
            correctAnswersCount: 0,
            completed: false)))
    var subject: SubjectModel = SubjectModel(
        dto: SubjectDto(
            id: 0,
            subject: "Math",
            photo: nil,
            questionsCount: 0,
            answeredQuestionsCount: 0,
            correctAnswersCount: 0,
            completed: true
        )
    )
    var isLoading = false
    var answerResultType: AnswerResultType? = nil
    var remindingSeconds = 0
    var buttonTitle: String = ""
    var isContentValid: Bool = false
    var isLastQuestion: Bool = false
    
    func getQuestions() { }
    func answerQuestion(answer: QuestionAnswerModel, isAdditionalQuestions: Bool, completion: @escaping (AnswerResultType)->()) { }
}
