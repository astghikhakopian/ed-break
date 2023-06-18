//
//  QuestionsRepository.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 14.11.22.
//

import Combine
import Moya
import Foundation

protocol QuestionsRepository {
    
    func getQuestions(subjectId: Int, completion: @escaping(Result<QuestionsContainerDto, Error>) -> Void)
    func answerQuestions(answerId: Int, index: Int, questionType: QuestionType, completion: @escaping (Result<QuestionResultDto, Error>) -> Void)
}

final class DefaultQuestionsRepository: MoyaProvider<QuestionsRoute>, QuestionsRepository, ObservableObject {
    
    func getQuestions(subjectId: Int, completion: @escaping(Result<QuestionsContainerDto, Error>) -> Void) {
        requestDecodable(.getQuestions(subjectId: subjectId), completion: completion)
    }
    
    func answerQuestions(answerId: Int, index: Int, questionType: QuestionType, completion: @escaping (Result<QuestionResultDto, Error>) -> Void) {
        requestDecodable(.answerQuestion(answerId: answerId, index: index, questionType: questionType), completion: completion)
    }
}
