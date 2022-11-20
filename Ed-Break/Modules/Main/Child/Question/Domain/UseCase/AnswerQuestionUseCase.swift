//
//  AnswerQuestionUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 19.11.22.
//

import Foundation

class AnswerQuestionUseCase: QuestionsUseCase {
    
    func execute(questionId: Int, answerId: Int, completion: @escaping (Error?) -> Void) {
        questionsRepository.answerQuestions(questionId: questionId, answerId: answerId, completion: completion)
    }
}
