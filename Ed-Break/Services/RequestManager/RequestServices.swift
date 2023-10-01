//
//  RequestServices.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.10.22.
//

import Foundation

enum RequestServices {
    
    enum Users {
        // prod
//        static let baseUrl: URL = URL(string: "https://back.ed-break.app")!
//        static let apiQueue: DispatchQueue = .init(label: "https://back.ed-break.app", qos: .default, attributes: .concurrent)
        
        // dev
//         static let baseUrl: URL = URL(string: "https://back-ed-break-dev.appelloproject.xyz")!
//         static let apiQueue: DispatchQueue = .init(label: "back-ed-break-dev.appelloproject.xyz", qos: .default, attributes: .concurrent)
        
        // stage Appello
//        static let baseUrl: URL = URL(string: "https://back-ed-break-stage.appelloproject.xyz")!
//        static let apiQueue: DispatchQueue = .init(label: "https://back-ed-break-stage.appelloproject.xyz", qos: .default, attributes: .concurrent)
        
        // stage Ed-Break
        static let baseUrl: URL = URL(string: "https://back-stage.ed-break.app")!
        static let apiQueue: DispatchQueue = .init(label: "https://back-stage.ed-break.app", qos: .default, attributes: .concurrent)
    }
    
    enum Post {
        
        static let baseUrl: URL = URL(string: "https://api.github.com")!
        static let apiQueue: DispatchQueue = .init(label: "org.github.api", qos: .default, attributes: .concurrent)
    }
}
