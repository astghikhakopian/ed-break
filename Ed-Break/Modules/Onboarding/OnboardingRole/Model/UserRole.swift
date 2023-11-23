//
//  UserRole.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 23.10.23.
//

import SwiftUI

enum UserRole {
    
    case parent
    case child
    
    var title: String {
        switch self {
        case .parent:
            return "onboarding.parent.title"
        case .child:
            return "onboarding.child.title"
        }
    }
    
    var image: Image {
        switch self {
        case .parent:
            return Image("onboarding.parent")
        case .child:
            return Image("onboarding.child")
        }
    }
}
