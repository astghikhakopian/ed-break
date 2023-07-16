//
//  DefaultTextToSpeachManager.swift
//  Ed-Break
//
//  Created by MEKHAK GHAPANTSYAN on 17.05.23.
//

import Foundation
import SwiftUI
import AVKit

typealias SpeechUtterance = AVSpeechUtterance
typealias SpeechBoundary = AVSpeechBoundary

class DefaultTextToSpeachManager: NSObject, ObservableObject {
    
    // MARK: - Public Properties
    
    @Published var isSpeaking = false
    var completion: ((QuestionsViewModel.CurrentReadingItem?) -> Void)?
    public static let sharedInstance = DefaultTextToSpeachManager()
    
    // MARK: - Private Properties
    
    private var synthesizer = AVSpeechSynthesizer()
    private let audioSession = AVAudioSession.sharedInstance()
    private let voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Karen-compact")
    private let rate: Float = 0.45
    
    
    // MARK: - Lifecycle
    
    private override init() {
        super.init()
        synthesizer.delegate = self
        
        do {
            try audioSession.setCategory(.playback)
            try audioSession.setActive(true)
        } catch {
            print("Could not activate audioSession.")
        }
    }
    
    deinit {
        synthesizer.delegate = nil
    }
}


// MARK: - DefaultTextToSpeachManager

extension DefaultTextToSpeachManager: TextToSpeachManager {
    
    func read(question: QusetionModel, after timeInterval: TimeInterval, completion: @escaping (QuestionsViewModel.CurrentReadingItem?) -> Void) {
        self.completion = completion
        DispatchQueue.global().asyncAfter(deadline: .now() + timeInterval) { [weak self] in
            self?.stop(at: .immediate)
            let utterance = AVSpeechUtteranceExtended(
                string: ("The question is: " + (question.questionText?.replacingOccurrences(of: "-", with: "minus") ?? "")  + ". "),
                teadingItemType: .question)
            utterance.voice = self?.voice
            utterance.rate = self?.rate ?? 1
            
            self?.speak(utterance)
            for i in 0..<question.questionAnswer.count {
                let utterance = AVSpeechUtteranceExtended(
                    string: "The" + (i+1).convertToOrdinal() + " answer is " + (question.questionAnswer[i].answer ?? "").replacingOccurrences(of: "-", with: "minus") + ".",
                    teadingItemType: .option(i))
                utterance.voice = self?.voice
                utterance.rate = self?.rate ?? 1
                self?.speak(utterance)
            }
        }
    }
    
    func speak(_ utterance: SpeechUtterance) {
        DispatchQueue.global().async { [weak self] in
            self?.synthesizer.speak(utterance)
        }
    }
    
    func stop(at boundary: SpeechBoundary) {
        self.synthesizer.stopSpeaking(at: boundary)
    }
}


// MARK: - AVSpeechSynthesizerDelegate

extension DefaultTextToSpeachManager: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        isSpeaking = true
        guard let utterance = utterance as? AVSpeechUtteranceExtended else { return }
        utterance.voice = voice
        completion?(utterance.teadingItemType)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
        guard let utterance = utterance as? AVSpeechUtteranceExtended else { return }
        utterance.voice = voice
        completion?(nil)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        isSpeaking = false
        guard let utterance = utterance as? AVSpeechUtteranceExtended else { return }
        utterance.voice = voice
        completion?(nil)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        isSpeaking = false
        guard let utterance = utterance as? AVSpeechUtteranceExtended else { return }
        utterance.voice = voice
        completion?(nil)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        guard let utterance = utterance as? AVSpeechUtteranceExtended else { return }
        utterance.voice = voice
        completion?(utterance.teadingItemType)
    }
}


extension Int {
    func convertToOrdinal() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        
        guard let ordinalString = numberFormatter.string(from: NSNumber(value: self)) else {
            return "\(self)"
        }
        
        return ordinalString
    }
}


class AVSpeechUtteranceExtended: AVSpeechUtterance {
    let teadingItemType: QuestionsViewModel.CurrentReadingItem?
    
    init(string: String, teadingItemType: QuestionsViewModel.CurrentReadingItem) {
        self.teadingItemType = teadingItemType
        super.init(string: string)
    }
    
    required init?(coder: NSCoder) {
        self.teadingItemType = nil
        super.init(coder: coder)
    }
}
