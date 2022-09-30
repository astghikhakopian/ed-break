//
//  BasicAuthenticationPlugin.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.10.22.
//

import Foundation
import Moya

final class BasicAuthenticationPlugin: PluginType {
    let tokenClosure: AccessTokenPlugin.TokenClosure
    
    init(tokenClosure: @escaping AccessTokenPlugin.TokenClosure) {
        self.tokenClosure = tokenClosure
    }
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
    #if DEBUG
        if let body = request.httpBody,
           let str = String(data: body, encoding: .utf8) {
            
                print("request to send: \(str))")
            
        }
    #endif
        //        if let target = target as? WeatherRequestManagerRoute {
        //            switch target {
        //            case .authenticate(_):
        //                return request
        //            default:
        //                break
        //            }
        //        }
        // var request = request
        // tokenClosure(AuthorizationType.basic)
        // request.addValue("BASIC \(tokenClosure(.basic))", forHTTPHeaderField: "Authorization")
        return request
    }
}
