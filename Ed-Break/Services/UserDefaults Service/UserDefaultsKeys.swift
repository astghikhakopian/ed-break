//
//  UserDefaultsKeys.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.10.22.
//

import Foundation

extension UserDefaults {
    
    struct Key: RawRepresentable {
        var rawValue: String
    }
}

extension UserDefaults.Key {
    
    struct User {
        
        static let token = UserDefaults.Key(rawValue: "User.token")
        static let isLoggedIn = UserDefaults.Key(rawValue: "User.isLoggedIn")
    }
}

