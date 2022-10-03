//
//  ChildrenView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 03.10.22.
//

import SwiftUI

struct ChildrenView: View {
    
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
                    content: { Text("uhj") })
            }
        }
    }
}

private extension ChildrenView {
    
    var content: some View {
        ZStack(alignment: .leading) {
            Color.appWhite
                .cornerRadius(cornerRadius)
                .shadow(color: .shadow, radius: 40, x: 0, y: 20)
            VStack(spacing: spacing) {
                Text("children.description")
                    .font(.appHeadline)
                    .foregroundColor(.primaryText)
                    .multilineTextAlignment(.center)
                ChildCell(name: "Emma", grade: .second, state: Binding.constant(.connected), scanAction: {})
                ChildCell(name: "David", grade: .third, state: Binding.constant(.scan), scanAction: {})
            }.padding(padding)
        }
    }
}


struct ChildrenView_Previews: PreviewProvider {
    static var previews: some View {
        ChildrenView()
    }
}
