//
//  ParentSettingsCellType.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 24.10.22.
//

import SwiftUI

enum ParentSettingsCellType: CaseIterable {
    case childDevices, inviteParents, termsAndConditions, rateTheApp, deleteAccount
    
    var image: Image {
        switch self {
        case .childDevices:
            return .Settings.mobile
        case .inviteParents:
            return .Settings.addparent
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
        case .inviteParents:
            return "main.parent.settings.addParents"
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
        case .childDevices, .inviteParents: return true
        case .termsAndConditions, .rateTheApp, .deleteAccount: return false
        }
    }
    
    var isDeviderShown: Bool {
        switch self {
        case .childDevices, .termsAndConditions, .inviteParents: return true
        case .rateTheApp, .deleteAccount: return false
        }
    }
}
