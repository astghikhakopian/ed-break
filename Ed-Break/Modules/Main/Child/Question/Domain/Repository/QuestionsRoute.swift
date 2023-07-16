//
//  QuestionsRoute.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 14.11.22.
//

import Foundation
import Moya

enum QuestionType: String {
    case additional = "additional"
    case main = "main"
}

enum QuestionsRoute: TargetType {
    
    case getQuestions(subjectId: Int)
    case answerQuestion(answerId: Int, index: Int, questionType: QuestionType)
    
    var baseURL: URL {
        return RequestServices.Users.baseUrl
    }
    
    var path: String {
        switch self {
        case .getQuestions:
            return "/questions/subject-questions/"
        case .answerQuestion:
            return "/questions/question-answer/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getQuestions:
            return .get
        case .answerQuestion:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getQuestions(let subjectId):
            return .requestParameters(
                parameters: [
                    "subject_id" : subjectId
                ],
                encoding: URLEncoding.queryString
            )
        case .answerQuestion(let answerId, let index, let questionType):
            return .requestParameters(
                parameters: [
                    "answerId": answerId
                ],
                encoding: JSONEncoding.default
            )
        }
    }
    
    var headers: [String: String]? {
        let token: TokenModel? = UserDefaultsService().getObject(forKey: .ChildUser.token)
        let accessToken = token?.access ?? ""
        return [
            "Content-Type": "application/json",
            "accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]}
}
