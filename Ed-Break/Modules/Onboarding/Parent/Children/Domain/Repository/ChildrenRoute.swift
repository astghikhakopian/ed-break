//
//  ChildrenRoute.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 04.10.22.
//

import Foundation
import Moya

enum ChildrenRoute: TargetType {
    
    case getChildren
    case getCoachingChildren(payload: TimePeriod)
    case getChildDetails(payload: GetChildDetailsPayload)
    case pairChild(payload: PairChildPayload)
    case checkConnection(payload: PairChildPayload)
    
    case getSubjects
    
    var baseURL: URL {
        return RequestServices.Users.baseUrl
    }
    
    var path: String {
        switch self {
        case .getChildren:
            return "/users/child"
        case .getChildDetails:
            return "/users/get-child/"
        case .getCoachingChildren:
            return "/questions/coaching/"
        case .pairChild:
            return "/users/child-device/"
        case .checkConnection:
            return "/users/child-status/"
        case .getSubjects:
            return "/users/child-home/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getChildren:
            return .get
        case .getChildDetails:
            return .get
        case .getCoachingChildren:
            return .get
        case .pairChild:
            return .patch
        case .checkConnection:
            return .post
        case .getSubjects:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getChildren:
            return .requestParameters(parameters: [
                "limit": "100",
                "offset": "0"
            ], encoding: URLEncoding.queryString)
        case .getChildDetails(let payload):
            return .requestParameters(parameters: [
                "child_id": payload.id,
                "education_period": payload.educationPeriod.key,
                "activity_period": payload.activityPeriod.key
            ], encoding: URLEncoding.queryString)
        case .getCoachingChildren(let payload):
            return .requestParameters(parameters: [
                "education_period": "\(payload.key)"
            ], encoding: URLEncoding.queryString)
        case .pairChild(let payload):
            return .requestParameters(parameters: [
                "child_id": payload.id,
                "child_device_token": payload.deviceToken
            ], encoding: URLEncoding.queryString)
        case .checkConnection(let payload):
            return .requestParameters(parameters: [
                "device_token": payload.deviceToken
            ], encoding: URLEncoding.queryString)
        case .getSubjects:
            return .requestParameters(parameters: [ :
            ], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getSubjects:
            let token: TokenModel? = UserDefaultsService().getObject(forKey: .ChildUser.token)
            let accessToken = token?.access ?? ""
            return [
                "Content-Type": "application/json",
                "accept": "application/json",
                "Authorization": "Bearer \(accessToken)"
            ]
        case .checkConnection:
            return [:]
        default:
            let token: TokenModel? = UserDefaultsService().getObject(forKey: .User.token)
            let accessToken = token?.access ?? ""
            return [
                "Content-Type": "application/json",
                "accept": "application/json",
                "Authorization": "Bearer \(accessToken)"
            ]}
    }
}

