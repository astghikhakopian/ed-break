//
//  DefaultTextToSpeachManager.swift
//  Ed-Break
//
//  Created by MEKHAK GHAPANTSYAN on 17.05.23.
//

import Foundation

import AVKit

typealias SpeechUtterance = AVSpeechUtterance
typealias SpeechBoundary = AVSpeechBoundary

class DefaultTextToSpeachManager: NSObject, ObservableObject {
    
    // MARK: - Public Properties
    
    @Published var isSpeaking = false
    
    
    // MARK: - Private Properties
    
    private var synthesizer = AVSpeechSynthesizer()
    private let audioSession = AVAudioSession.sharedInstance()
    
    
    // MARK: - Lifecycle
    
    override init() {
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
    
    func read(question: QusetionModel, after timeInterval: TimeInterval) {
        DispatchQueue.global().asyncAfter(deadline: .now() + timeInterval) { [weak self] in
            let utterance = AVSpeechUtterance(string: ("The question is" + (question.questionText ?? "")  + ". "))
            self?.speak(utterance)
            self?.stop(at: .immediate)
            for i in 0..<question.questionAnswer.count {
                let utterance = AVSpeechUtterance(string: "The" + (i+1).convertToOrdinal() + " answer is " + (question.questionAnswer[i].answer ?? ""))
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
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        isSpeaking = false
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        isSpeaking = false
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        isSpeaking = true
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
