//
//  OnboardingRoleCell.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 29.09.22.
//

import SwiftUI

enum UserRole {
    case parent
    case child
}

struct OnboardingRoleCell<Content> : View where Content : View {
    
    let role: UserRole
    @ViewBuilder let content: (() -> Content)
    
    var body: some View {
        ZStack {
            Color.appWhite
            NavigationLink(destination: content()) {
                ZStack {
                    Color.appClear
                    VStack(spacing: 18) {
                        role.image
                        Text(LocalizedStringKey(role.title)).font(.appTitle)
                    }
                }
            }
        }
        .cornerRadius(12)
        .shadow(color: .shadow, radius: 40, x: 0, y: 20)
    }
}

struct OnboardingRoleCell_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingRoleCell(role: .parent) {}
    }
}

fileprivate extension UserRole {
    
    var image: Image {
        switch self {
        case .parent:
            return Image("onboarding.parent")
        case .child:
            return Image("onboarding.child")
        }
    }
    
    var title: String {
        switch self {
        case .parent:
            return "onboarding.parent.title"
        case .child:
            return "onboarding.child.title"
        }
    }
}
