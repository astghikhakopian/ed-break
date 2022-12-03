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
    func getAdditionalQuestions(completion: @escaping(Result<QuestionsContainerDto, Error>) -> Void)
    func answerQuestions(questionId: Int, answerId: Int, completion: @escaping(Error?) -> Void)
    func resultOfAdditionalQuestions(completion: @escaping(Error?) -> Void)
}

final class DefaultQuestionsRepository: MoyaProvider<QuestionsRoute>, QuestionsRepository, ObservableObject {
    
    func getQuestions(subjectId: Int, completion: @escaping(Result<QuestionsContainerDto, Error>) -> Void) {
        requestDecodable(.getQuestions(subjectId: subjectId), completion: completion)
    }
    
    func getAdditionalQuestions(completion: @escaping(Result<QuestionsContainerDto, Error>) -> Void) {
        requestDecodable(.getAdditionalQuestions, completion: completion)
    }
    
    func answerQuestions(questionId: Int, answerId: Int, completion: @escaping (Error?) -> Void) {
        requestSimple(.answerQuestion(questionId: questionId, answerId: answerId), completion: completion)
    }
    func resultOfAdditionalQuestions(completion: @escaping(Error?) -> Void) {
        requestSimple(.resultOfAdditionalQuestions, completion: completion)
    }
}
