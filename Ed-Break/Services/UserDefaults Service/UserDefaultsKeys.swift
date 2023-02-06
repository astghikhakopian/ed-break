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
    
    struct ChildUser {
        
        static let token = UserDefaults.Key(rawValue: "ChildUser.token")
        static let isLoggedIn = UserDefaults.Key(rawValue: "ChildUser.isLoggedIn")
        static let restrictedApps = UserDefaults.Key(rawValue: "ChildUser.restrictedApps")
        static let selectionToEncourage = UserDefaults.Key(rawValue: "ChildUser.selectionToEncourage")
        static let selectionToDiscourage = UserDefaults.Key(rawValue: "ChildUser.selectionToDiscourage")
        static let threshold = UserDefaults.Key(rawValue: "ChildUser.threshold")
        static let remindingMinutes = UserDefaults.Key(rawValue: "ChildUser.remindingMinutes")
        static let lastIncreaseTime = UserDefaults.Key(rawValue: "ChildUser.lastIncreaseTime")
    }
}
