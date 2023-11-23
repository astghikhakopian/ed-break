//
//  ChildToFamilyView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 26.06.23.
//

import SwiftUI

struct ChildToFamilyView<M: FamilySharingViewModeling>: View {
    
    @ObservedObject var viewModel: M
    
    var body: some View {
        MainBackground(
            title: "onboarding.addedChildToFamily.title",
            withNavbar: true
        ) {
            ZStack {
                ZStack(alignment: .bottom) {
                    Image.FamilySharing.addchildtofamily
                    LinearGradient(
                        gradient: Gradient(
                            colors: [.clear, .primaryPurple]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 300)
                }
                VStack(spacing: 0) {
                    Spacer()
                    NavigationButton(
                        title: "onboarding.addedChildToFamily.scanQR",
                        didTap: { viewModel.addParent() },
                        isLoading: $viewModel.isLoading,
                        shouldNavigateAfterLoading: true,
                        content: {
                            ChildDetailsView(
                                viewModel: ChildDetailsViewModel(
                                    addChildUseCase: AddChildUseCase(
                                        childDetailsRepository: DefaultChildDetailsRepository(
                                            plugins: [BasicAuthenticationPlugin()]
                                        )
                                    ),
                                    getAllSubjectsUseCase: GetAllSubjectsUseCase(
                                        childDetailsRepository: DefaultChildDetailsRepository()),
                                    pairChildUseCase: PairChildUseCase(
                                        childrenRepository: DefaultChildrenRepository())
                                )
                            )
                        }
                    )
                    NavigationSecondaryButton(
                        title: "onboarding.addedChildToFamily.howTo"
                    ) {
                        FamilySharingView(
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
}

struct ChildToFamilyView_Previews: PreviewProvider {
    static var previews: some View {
        ChildToFamilyView(viewModel: FamilySharingViewModel(addParentUseCase: AddParentUseCase(familySharingRepository: DefaultFamilySharingRepository()), localStorageService: UserDefaultsService()))
    }
}
