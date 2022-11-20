//
//  QuestionsRoute.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 14.11.22.
//

import Foundation
import Moya
import UIKit
/*
 enum QuestionsRoute: TargetType {
 
 case getQuestions(subjectId: Int)
 
 var authorizationType: AuthorizationType? {
 .bearer
 }
 
 var baseURL: URL {
 return RequestServices.Users.baseUrl
 }
 
 var path: String {
 switch self {
 case .getQuestions(let subjectId):
 return "​/questions/subject/" //?subject_id=\(subjectId)"
 }
 }
 
 var method: Moya.Method {
 switch self {
 case .getQuestions:
 return .get
 }
 }
 
 var task: Task {
 switch self {
 case .getQuestions(let subjectId):
 return .requestParameters(
 parameters: ["subject_id": subjectId],
 encoding: URLEncoding.queryString)
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
 */

import Foundation
import Moya

enum QuestionsRoute: TargetType {
    
    case getQuestions(subjectId: Int)
    case answerQuestion(questionId: Int, answerId: Int)
    
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
        case .answerQuestion(let questionId, let answerId):
            return .requestParameters(
                parameters: [
                    "question": questionId,
                    "answer": answerId
                ],
                encoding: URLEncoding.queryString
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

