//
//  ParentSettingsCellType.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 24.10.22.
//

import SwiftUI

enum ParentSettingsCellType: CaseIterable {
    case childDevices, termsAndConditions, rateTheApp, deleteAccount
    
    var image: Image {
        switch self {
        case .childDevices:
            return .Settings.mobile
        case .termsAndConditions:
            return .Settings.asterisk
        case .rateTheApp:
            return .Settings.star
        case .deleteAccount:
            return .Settings.delete
        }
    }
    
    var title: String {
        switch self {
        case .childDevices:
            return "main.parent.settings.childDevices"
        case .termsAndConditions:
            return "main.parent.settings.termsAndConditions"
        case .rateTheApp:
            return "main.parent.settings.rateTheApp"
        case .deleteAccount:
            return "main.parent.settings.delete"
        }
    }
    
    var isMoreShown: Bool {
        switch self {
        case .childDevices: return true
        case .termsAndConditions, .rateTheApp, .deleteAccount: return false
        }
    }
    
    var isDeviderShown: Bool {
        switch self {
        case .childDevices, .termsAndConditions: return true
        case .rateTheApp, .deleteAccount: return false
        }
    }
}
