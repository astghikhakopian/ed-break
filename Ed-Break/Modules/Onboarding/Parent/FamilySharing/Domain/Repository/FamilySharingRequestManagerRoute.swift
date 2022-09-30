//
//  FamilySharingRequestManagerRoute.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.10.22.
//

import Foundation
import Moya

enum FamilySharingRequestManagerRoute: TargetType {
    
    case addParent(username: String)
    
    var baseURL: URL {
        return RequestServices.Users.baseUrl
    }

    var path: String {
        switch self {
        case .addParent:
            return "/users/parent"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .addParent:
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
                encoding: URLEncoding.default
            )
        }
    }

    var headers: [String: String]? {[
//        "Content-Type": "application/json",
        "accept": "application/json",
        "X-CSRFToken": "jXBDXw7atmkhWpQLKzy4jEmvCmOtPrA9lx04Ri6NpuoiTKf4YLV6XgdDO9KzZB6f",
        "Referer": "https://back-ed-break-dev.appelloproject.xyz"
    ]}
}

