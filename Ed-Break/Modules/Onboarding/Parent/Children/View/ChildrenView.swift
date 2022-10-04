//
//  ChildrenView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 03.10.22.
//

import SwiftUI

struct ChildrenView<M: ChildrenViewModeling>: View {
    
    @StateObject var viewModel: M
    
    private let cornerRadius = 12.0
    private let spacing = 14.0
    private let padding = 20.0
    private let gap = 20.0
    
    var body: some View {
        MainBackground(title: "onboarding.children.title", withNavbar: true) {
            VStack(spacing: gap) {
                content
                NavigationButton(
                    title: "common.continue",
                    didTap: { },
                    isLoading: $viewModel.isLoading,
                    content: { Text("uhj") })
            }
        }.onAppear {
            viewModel.getChildren()
        }
    }
}

private extension ChildrenView {
    
    var content: some View {
        ZStack(alignment: .leading) {
            Color.appWhite
                .cornerRadius(cornerRadius)
                .shadow(color: .shadow, radius: 40, x: 0, y: 20)
            VStack(alignment: .leading, spacing: spacing) {
                Text("children.description")
                    .font(.appHeadline)
                    .foregroundColor(.primaryText)
                    .multilineTextAlignment(.center)
                ForEach(viewModel.children.results, id: \.id) { child in
                    ChildCell(name: child.name, grade: child.grade, imageUrl: child.photoUrl, state: Binding.constant(.scan), scanAction: {})
                }
            }.padding(spacing)
        }
    }
}


struct ChildrenView_Previews: PreviewProvider {
    static var previews: some View {
        ChildrenView(viewModel: MockChildrenViewModeling())
    }
}
