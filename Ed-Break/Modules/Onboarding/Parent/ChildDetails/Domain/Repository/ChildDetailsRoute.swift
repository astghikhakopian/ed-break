//
//  ChildDetailsRoute.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 03.10.22.
//

import Foundation
import Moya
import UIKit

enum ChildDetailsRoute: TargetType, AccessTokenAuthorizable {
    
    case addChild(payload: CreateChildPayload)
    
    var authorizationType: AuthorizationType? {
        .bearer
    }
    
    var baseURL: URL {
        return RequestServices.Users.baseUrl
    }
    
    var path: String {
        switch self {
        case .addChild:
            return "/users/child/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .addChild:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .addChild(let payload):
            
            var formData = [MultipartFormData]()
            
            if let nameData = payload.name.data(using: .utf8) {
                formData.append(MultipartFormData(provider: .data(nameData), name: "name"))
            }
            if let gradeData = payload.grade.key.data(using: .utf8) {
                formData.append(MultipartFormData(provider: .data(gradeData), name: "grade"))
            }
            if let photo = payload.photo, let photoData = photo.jpegData(compressionQuality: 1.0) {
                formData.append(MultipartFormData(provider: .data(photoData), name: "photo.jpeg", fileName: "file.jpeg", mimeType: "image/jpeg"))
            }
            if let restrictionTime = payload.restrictionTime, let restrictionTimeData = String(restrictionTime).data(using: .utf8) {
                formData.append(MultipartFormData(provider: .data(restrictionTimeData), name: "restriction_timeData"))
            }
            
            return .uploadMultipart(formData)
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

