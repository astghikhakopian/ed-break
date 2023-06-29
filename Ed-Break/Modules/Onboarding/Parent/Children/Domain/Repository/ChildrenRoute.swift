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
    case removeDevice(payload: PairChildPayload)
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
            return "/users/child-device-add/"
        case .removeDevice(let device):
            return "/users/child-device-delete/\(device.deviceToken)/"
        case .checkConnection:
            return "/users/child-device-login/"
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
        case .removeDevice:
            return .delete
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
                "childId": payload.id,
                "deviceToken": payload.deviceToken,
                "deviceName": payload.childDeviceName,
                "deviceType": payload.childDeviceModel
            ], encoding: JSONEncoding.default)
        case .removeDevice:
            return .requestParameters(
                parameters: [:],
                encoding: URLEncoding.queryString
            )
        case .checkConnection(let payload):
            return .requestParameters(parameters: [
                "deviceToken": payload.deviceToken
            ], encoding: JSONEncoding.default)
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

