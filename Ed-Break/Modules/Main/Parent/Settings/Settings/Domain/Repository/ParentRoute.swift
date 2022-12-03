//
//  ParentRoute.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 24.10.22.
//

import Foundation
import Moya
import UIKit

enum ParentRoute: TargetType, AccessTokenAuthorizable {
    
    case deleteParent
    
    var authorizationType: AuthorizationType? {
        .bearer
    }
    
    var baseURL: URL {
        return RequestServices.Users.baseUrl
    }
    
    var path: String {
        switch self {
        case .deleteParent:
            return "/users/delete-account/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .deleteParent:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .deleteParent:
            return .requestParameters(
                parameters: [:],
                encoding: URLEncoding.queryString
            )
        }
    }
    
    var headers: [String: String]? {
        let userDefaultsService = UserDefaultsService()
        let token: TokenModel?
        if userDefaultsService.getPrimitive(forKey: .User.isLoggedIn) ?? false {
            token = userDefaultsService.getObject(forKey: .User.token)
        } else {
            token = userDefaultsService.getObject(forKey: .ChildUser.token)
        }
        let accessToken = token?.access ?? ""
        return [
            "Content-Type": "application/json",
            "accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]}
}

