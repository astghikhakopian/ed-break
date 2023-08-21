//
//  ReadQuestionViewModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 16.08.23.
//

import UIKit

final class ReadQuestionViewModel: ReadQuestionViewModeling {
    
    enum CurrentReadingItem: Equatable {
        case question
        case option(Int)
    }
    
    
    @Published var currentReadingItem: CurrentReadingItem?
    
    private let textToSpeachManager: TextToSpeachManager
    
    
    init(textToSpeachManager: TextToSpeachManager) {
        self.textToSpeachManager = textToSpeachManager
    }
    
    
    func startPlayingQuestion(currentQuestion: QusetionModel) {
        guard !(currentQuestion.questionText ?? "").isEmpty else { return }
        stopPlayingQuestion()
        textToSpeachManager.read(question: currentQuestion, after: 0) { [weak self] in
            self?.currentReadingItem = $0
        }
    }
    
    func startPlayingQuestion(currentQuestion: OfflineQusetionModel) {
        guard !currentQuestion.questionText.isEmpty else { return }
        stopPlayingQuestion()
        let questionModel = QusetionModel()//(offlineModel: currentQuestion)
        textToSpeachManager.read(question: questionModel, after: 0) { [weak self] in
            self?.currentReadingItem = $0
        }
    }
    
    func stopPlayingQuestion() {
        textToSpeachManager.stop(at: .immediate)
    }
    
    func isCurrentReading(currentQuestion: QusetionModel, answer: QuestionAnswerModel) -> Bool {
        if case let .option(i) = currentReadingItem,
           let index = currentQuestion.questionAnswer.firstIndex(of: answer) {
            return i == index
        }
        return false
    }
    func isCurrentReading(currentQuestion: OfflineQusetionModel?, answer: OfflineQuestionAnswerModel) -> Bool {
        guard let currentQuestion = currentQuestion else { return false }
        if case let .option(i) = currentReadingItem,
           let index = currentQuestion.answers.firstIndex(where: {$0.id == answer.id}) {
            return i == index
        }
        return false
    }
    
    deinit {
        stopPlayingQuestion()
    }
}

// MARK: - Preview

final class MockReadQuestionViewModel: ReadQuestionViewModeling {
    
    var currentReadingItem: ReadQuestionViewModel.CurrentReadingItem? = nil
    
    func startPlayingQuestion(currentQuestion: QusetionModel) { }
    func startPlayingQuestion(currentQuestion: OfflineQusetionModel) { }
    func stopPlayingQuestion() { }
    func isCurrentReading(currentQuestion: QusetionModel, answer: QuestionAnswerModel) -> Bool { return false }
    func isCurrentReading(currentQuestion: OfflineQusetionModel?, answer: OfflineQuestionAnswerModel) -> Bool { return false }
}
