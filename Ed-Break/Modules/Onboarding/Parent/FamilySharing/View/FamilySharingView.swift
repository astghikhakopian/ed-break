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
    
    private let cornerRadius = 12.0
    private let spacing = 25.0
    private let gap = 15.0
    private let settingsUrl = URL(string: UIApplication.openSettingsURLString)!
    
    var body: some View {
        
        MainBackground(title: "onboarding.familySharing.title", withNavbar: true) {
            VStack(spacing: gap) {
                steps
                info
                NavigationButton(
                    title: "familySharing.done",
                    didTap: { viewModel.addParent() },
                    content: { ChildDetailsView(viewModel: ChildDetailsViewModel(addChildUseCase: AddChildUseCase(childDetailsRepository: DefaultChildDetailsRepository(plugins: [BasicAuthenticationPlugin()])))) })
                CancelButton(action: {
                    openURL(settingsUrl)
                }, title: "familySharing.cancel")
            }
        }
    }
}

private extension FamilySharingView {
    
    var steps: some View {
        ZStack(alignment: .leading) {
            Color.appWhite
                .cornerRadius(cornerRadius)
                .shadow(color: .shadow, radius: 40, x: 0, y: 20)
            VStack(alignment: .leading, spacing: spacing) {
                ForEach(FamilySharingCellType.allCases, id: \.self) {
                    FamilySharingCell(type: $0)
                }
            }.padding(spacing)
        }
    }
    
    var info: some View {
        ZStack(alignment: .leading) {
            Color.appWhite
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
