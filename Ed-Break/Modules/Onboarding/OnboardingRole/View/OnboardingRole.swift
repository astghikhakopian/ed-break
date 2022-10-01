//
//  OnboardingRole.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 26.09.22.
//

import SwiftUI

struct OnboardingRole: View {
    
    private let cellHeight = 214.0
    private let spacing = 19.0
    
    var body: some View {
        NavigationView {
            MainBackground(title: "onboarding.role", withNavbar: false) {
                VStack(spacing: spacing) {
                    OnboardingRoleCell(role: .parent) {
                        FamilySharing(viewModel: FamilySharingViewModel(addParentUseCase: AddParentUseCase(familySharingRepository: DefaultFamilySharingRepository()), localStorageService: UserDefaultsService()))
                    }.frame(height: cellHeight)
                    
                    OnboardingRoleCell(role: .child) {
                        // FamilySharing()
                    }.frame(height: cellHeight)
                }
            }
        }
        .foregroundColor(.appBlack)
        .accentColor(.appClear)
    }
}

struct OnboardingRole_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingRole()
    }
}
