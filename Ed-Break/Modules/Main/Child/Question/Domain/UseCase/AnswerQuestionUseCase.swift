//
//  AnswerQuestionUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 19.11.22.
//

import Foundation

class AnswerQuestionUseCase: QuestionsUseCase {
    
    func execute(answerId: Int, index: Int, questionType: QuestionType, completion: @escaping (Result<QuestionResultDto, Error>) -> Void) {
        questionsRepository.answerQuestions(answerId: answerId, index: index, questionType: questionType, completion: completion)
    }
}
