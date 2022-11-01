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
    case updateChild(id: Int, payload: CreateChildPayload)
    case deleteChild(id: Int)
    
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
        case .updateChild(let id, _):
            return "/users/child/\(id)/"
        case .deleteChild(let id):
            return "/users/delete-child/\(id)/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .addChild:
            return .post
        case .updateChild:
            return .patch
        case .deleteChild:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .addChild(let payload):
            
            var formData = [MultipartFormData]()
            
            if let nameData = payload.name.data(using: .utf8) {
                formData.append(MultipartFormData(provider: .data(nameData), name: "name"))
            }
            if let gradeData = "\(payload.grade.rawValue)".data(using: .utf8) { //payload.gradekey.data(using: .utf8) {
                formData.append(MultipartFormData(provider: .data(gradeData), name: "grade"))
            }
            if let photo = payload.photo, let photoData = photo.jpegData(compressionQuality: 1.0) {
                formData.append(MultipartFormData(provider: .data(photoData), name: "photo", fileName: "file.jpeg", mimeType: "image/jpeg"))
            }
            if let restrictionTime = payload.restrictionTime, let restrictionTimeData = String(restrictionTime).data(using: .utf8) {
                formData.append(MultipartFormData(provider: .data(restrictionTimeData), name: "restriction_timeData"))
            }
            
            return .uploadMultipart(formData)
        case .updateChild(_, let payload):
            
            var formData = [MultipartFormData]()
            
            if let nameData = payload.name.data(using: .utf8) {
                formData.append(MultipartFormData(provider: .data(nameData), name: "name"))
            }
            if let gradeData = "\(payload.grade.rawValue)".data(using: .utf8) { //payload.gradekey.data(using: .utf8) {
                formData.append(MultipartFormData(provider: .data(gradeData), name: "grade"))
            }
            if let photo = payload.photo, let photoData = photo.jpegData(compressionQuality: 1.0) {
                formData.append(MultipartFormData(provider: .data(photoData), name: "photo", fileName: "file.jpeg", mimeType: "image/jpeg"))
            }
            if let restrictionTime = payload.restrictionTime, let restrictionTimeData = String(restrictionTime).data(using: .utf8) {
                formData.append(MultipartFormData(provider: .data(restrictionTimeData), name: "restriction_timeData"))
            }
            
            return .uploadMultipart(formData)
        case .deleteChild:
            return .requestParameters(
                parameters: [:],
                encoding: URLEncoding.queryString
            )
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

