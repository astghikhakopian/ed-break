//
//  CreateOrJoinFamilyView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 26.06.23.
//

import SwiftUI

struct CreateOrJoinFamilyView: View {
    
    var body: some View {
        MainBackground(title: "onboarding.createorjoinfamily.title", withNavbar: true) {
            VStack(spacing: 0) {
                Spacer()
                VStack(spacing: 20) {
                    Image.FamilySharing.createorjoinfamily
                    
                    Text("onboarding.createorjoinfamily.description")
                        .font(.appHeadline)
                        .foregroundColor(.appWhite)
                        .multilineTextAlignment(.center)
                }
                Spacer()
                NavigationButton(
                    title: "onboarding.createorjoinfamily.createfamily",
                    content: {
                        NavigationLazyView(
                            ChildToFamilyView(
                                viewModel: FamilySharingViewModel(
                                    addParentUseCase: AddParentUseCase(
                                        familySharingRepository: DefaultFamilySharingRepository()
                                    ),
                                    localStorageService: UserDefaultsService()
                                )
                            )
                        )
                    }
                )
                NavigationSecondaryButton(title: "onboarding.createorjoinfamily.joinfamily") {
                    JoinFamilyView(
                        viewModel: FamilySharingViewModel(
                            addParentUseCase: AddParentUseCase(
                                familySharingRepository: DefaultFamilySharingRepository()
                            ),
                            localStorageService: UserDefaultsService()
                        )
                    )
                }
            }
        }
    }
}

struct CreateOrJoinFamilyView_Previews: PreviewProvider {
    static var previews: some View {
        CreateOrJoinFamilyView()
    }
}
