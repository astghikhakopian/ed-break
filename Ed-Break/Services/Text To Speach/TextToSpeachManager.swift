//
//  TextToSpeachManager.swift
//  Ed-Break
//
//  Created by MEKHAK GHAPANTSYAN on 17.05.23.
//

import SwiftUI

protocol TextToSpeachManager {
    
    var isSpeaking: Bool { get }
    
    func read(
        question: QusetionModel,
        after timeInterval: TimeInterval,
        completion: @escaping (ReadQuestionViewModel.CurrentReadingItem?) -> Void
    )
    func speak(_ utterance: SpeechUtterance)
    func stop(at boundary: SpeechBoundary)
}
