//
//  RestrictionsRoute.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 10.11.22.
//

import Foundation
import Moya
import UIKit

enum RestrictionsRoute: TargetType, AccessTokenAuthorizable {
    
    case addRestriction(childId: Int, restrictions: String)
    case addInterruption(childId: Int, interruption: Int)
    
    var authorizationType: AuthorizationType? {
        .bearer
    }
    
    var baseURL: URL {
        return RequestServices.Users.baseUrl
    }
    
    var path: String {
        switch self {
        case .addRestriction(let childId, _):
            return "/users/child/\(childId)"
        case .addInterruption(let childId, _):
            return "/users/child/\(childId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .addRestriction:
            return .patch
        case .addInterruption:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .addRestriction(_, let restrictions):
            return .requestCompositeParameters(bodyParameters: ["restrictions" : restrictions], bodyEncoding:  JSONEncoding.prettyPrinted, urlParameters: [:])
        case .addInterruption(_, let interruption):
            return .requestCompositeParameters(bodyParameters: ["interruption" : interruption], bodyEncoding:  JSONEncoding.prettyPrinted, urlParameters: [:])
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

