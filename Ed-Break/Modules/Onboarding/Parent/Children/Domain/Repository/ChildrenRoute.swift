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
    case getChildDetails(payload: GetChildDetailsPayload)
    
    var baseURL: URL {
        return RequestServices.Users.baseUrl
    }
    
    var path: String {
        switch self {
        case .getChildren:
            return "/users/child/"
        case .getChildDetails:
            return "/users/get-child/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getChildren:
            return .get
        case .getChildDetails:
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
        }
    }
    
    var headers: [String: String]? {
        let token: TokenModel? = UserDefaultsService().getObject(forKey: .User.token)
        let accessToken = token?.access ?? ""
        return [
            "Content-Type": "application/json",
            "accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]}
}

