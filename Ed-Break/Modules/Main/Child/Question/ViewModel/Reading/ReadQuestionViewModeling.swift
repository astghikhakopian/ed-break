//
//  ReadQuestionViewModeling.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 16.08.23.
//

import SwiftUI

protocol ReadQuestionViewModeling: ObservableObject {
    
    var currentReadingItem: ReadQuestionViewModel.CurrentReadingItem? { get set }
    
    func startPlayingQuestion(currentQuestion: QusetionModel)
    func startPlayingQuestion(currentQuestion: OfflineQusetionModel)
    func stopPlayingQuestion()
    func isCurrentReading(currentQuestion: QusetionModel, answer: QuestionAnswerModel) -> Bool
    func isCurrentReading(currentQuestion: OfflineQusetionModel?, answer: OfflineQuestionAnswerModel) -> Bool
}
