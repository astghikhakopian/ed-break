//
//  FamilySharing.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 30.09.22.
//

import SwiftUI

struct FamilySharingView<M: FamilySharingViewModeling>: View {
    
    @ObservedObject var viewModel: M
    
    @Environment(\.openURL) private var openURL
    
    private let cells: [FamilySharingCellType] = [.settings, .appleId, .familySharing, .addChild, .returnBack]
    @State private var isContentValid = true
    private let cornerRadius = 12.0
    private let spacing = 25.0
    private let gap = 20.0
    private let settingsUrl = URL(string: UIApplication.openSettingsURLString)!
    
    var body: some View {
        
        MainBackground(title: "onboarding.familySharing.title", withNavbar: true) {
            VStack(spacing: gap) {
                steps
                info
                Spacer()
                    .frame(maxHeight: .infinity)
                NavigationButton(
                    title: "familySharing.done",
                    didTap: { viewModel.addParent() },
                    isContentValid: $isContentValid,
                    isLoading: $viewModel.isLoading,
                    shouldNavigateAfterLoading: true,
                    content: {
                        ChildDetailsView(
                            viewModel: ChildDetailsViewModel(
                                addChildUseCase: AddChildUseCase(
                                    childDetailsRepository: DefaultChildDetailsRepository(
                                        plugins: [BasicAuthenticationPlugin()])),
                                getAllSubjectsUseCase: GetAllSubjectsUseCase(
                                    childDetailsRepository: DefaultChildDetailsRepository()),
                                pairChildUseCase: PairChildUseCase(
                                    childrenRepository: DefaultChildrenRepository())))
                    }
                )
                CancelButton(
                    action: { openURL(settingsUrl) },
                    title: "familySharing.cancel",
                    isContentValid: .constant(true)
                )
            }
        }
    }
}

private extension FamilySharingView {
    
    var steps: some View {
        ZStack(alignment: .leading) {
            Color.primaryCellBackground
                .cornerRadius(cornerRadius)
                .shadow(color: .shadow, radius: 40, x: 0, y: 20)
            VStack(alignment: .leading, spacing: spacing) {
                ForEach(cells, id: \.self) {
                    FamilySharingCell(type: $0)
                }
            }.padding(spacing)
        }
    }
    
    var info: some View {
        ZStack(alignment: .leading) {
            Color.primaryCellBackground
                .cornerRadius(cornerRadius)
                .shadow(color: .shadow, radius: 40, x: 0, y: 20)
            VStack(alignment: .leading, spacing: spacing) {
                ForEach(FamilySharingInfoCellType.allCases, id: \.self) {
                    FamilySharingInfoCell(type: $0)
                }
            }.padding(spacing)
        }
    }
}

struct FamilySharing_Previews: PreviewProvider {
    static var previews: some View {
        FamilySharingView(viewModel: MockFamilySharingViewModel())
    }
}
