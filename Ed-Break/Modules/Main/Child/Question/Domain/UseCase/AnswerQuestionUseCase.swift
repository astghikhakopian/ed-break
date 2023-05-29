//
//  AnswerQuestionUseCase.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 19.11.22.
//

import Foundation

class AnswerQuestionUseCase: QuestionsUseCase {
    
    func execute(questionId: Int, answerId: Int, index: Int, questionType: QuestionType, subjectId: Int, completion: @escaping (Error?) -> Void) {
        questionsRepository.answerQuestions(questionId: questionId, answerId: answerId, index: index, questionType: questionType, subjectId: subjectId, completion: completion)
    }
}
