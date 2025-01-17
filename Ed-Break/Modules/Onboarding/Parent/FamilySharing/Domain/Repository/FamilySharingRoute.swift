//
//  FamilySharingRequestManagerRoute.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.10.22.
//

import Foundation
import Moya

enum FamilySharingRoute: TargetType {
    
    case addParent(username: String)
    case joinToFamily(currentDeviceToken: String, familyOwnerDeviceToken: String)
    case refreshToken
    
    var baseURL: URL {
        return RequestServices.Users.baseUrl
    }
    
    var path: String {
        switch self {
        case .addParent:
            return "/users/parent/"
        case .joinToFamily:
            return "/users/parent/"
        case .refreshToken:
            return "/api/token/refresh/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .addParent:
            return .post
        case .joinToFamily:
            return .post
        case .refreshToken:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .addParent(let username):
            return .requestParameters(
                parameters: [
                    "username": username
                ],
                encoding: URLEncoding.queryString
            )
        case .joinToFamily(let currentDeviceToken, let familyOwnerDeviceToken):
            return .requestParameters(
                parameters: [
                    "username": currentDeviceToken,
                    "organizer_username": familyOwnerDeviceToken
                ],
                encoding: URLEncoding.queryString
            )
        case .refreshToken:
            let token: TokenModel? = UserDefaultsService().getObject(forKey: .User.token)
            let childToken: TokenModel? = UserDefaultsService().getObject(forKey: .ChildUser.token)
            let refreshToken = token?.refresh ?? childToken?.refresh ?? ""
            return .requestParameters(
                parameters: [
                    "refresh": refreshToken
                ],
                encoding: JSONEncoding.default
            )
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case.addParent, .joinToFamily:
            return [
                "Content-Type": "application/json",
                "accept": "application/json"
            ]
        case .refreshToken:
            let token: TokenModel? = UserDefaultsService().getObject(forKey: .User.token)
            let accessToken = token?.access ?? ""
            return [
                "Content-Type": "application/json",
                "accept": "application/json",
                "Authorization": "Bearer \(accessToken)"
            ]}
    }
}

