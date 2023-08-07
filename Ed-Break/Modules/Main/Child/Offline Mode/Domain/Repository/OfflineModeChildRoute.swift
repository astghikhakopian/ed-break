//
//  OfflineModeChildRoute.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 03.08.23.
//

import Foundation
import Moya

enum OfflineModeChildRoute: TargetType {
    
    case getChild
    
    var baseURL: URL {
        return RequestServices.Users.baseUrl
    }
    
    var path: String {
        switch self {
        case .getChild:
            return "/offline-mode/child/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getChild:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getChild:
            return .requestParameters(
                parameters: [ : ],
                encoding: URLEncoding.queryString
            )
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getChild:
            let token: TokenModel? = UserDefaultsService().getObject(forKey: .ChildUser.token)
            let accessToken = token?.access ?? ""
            return [
                "Content-Type": "application/json",
                "accept": "application/json",
                "Authorization": "Bearer \(accessToken)"
            ]
        }
    }
}

