//
//  HomeView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 10.10.22.
//

import SwiftUI

struct DashboardView<M: ChildrenViewModeling>: View {
    
    @StateObject var viewModel: M
    @EnvironmentObject var model: DataModel
    
    private let cornerRadius = 12.0
    private let spacing = 14.0
    private let padding = 20.0
    private let gap = 20.0
    
    var body: some View {
        VStack {
            ScrollView {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(
                            CircularProgressViewStyle(tint: .appWhite))
                } else {
                    VStack(spacing: gap) {
                        content
                    }
                }
            }.onReceive(.Refresh.update) { _ in
                viewModel.getChildren()
                viewModel.getCoachingChildren()
            }
        }
    }
}

private extension DashboardView {
    
    var content: some View {
        
        ForEach(viewModel.children.results, id: \.id) { child in
            NavigationLink(
                destination:
                    NavigationLazyView(MainBackground(title: nil, withNavbar: true, hideBackButton: true) {
                        ChildProfileView(
                            viewModel: ChildProfileViewModel(
                                child: child,
                                getChildDetailsUseCase: GetChildDetailsUseCase(
                                    childrenRepository: DefaultChildrenRepository()),
                                addRestrictionUseCase: AddRestrictionUseCase(
                                    restrictionsRepository: DefaultRestrictionsRepository()),
                                addInterruptionUseCase: AddInterruptionUseCase(
                                    restrictionsRepository: DefaultRestrictionsRepository())))
                        .environmentObject(model)
                    }),
                label: { HomeChildCell(child: child) })
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(viewModel: MockChildrenViewModeling())
    }
}
