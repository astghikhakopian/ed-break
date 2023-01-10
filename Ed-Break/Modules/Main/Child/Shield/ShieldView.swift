//
//  ShieldView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 08.12.22.
//

import SwiftUI

struct ShieldView<M: QuestionsViewModeling>: View {
    
    @StateObject var viewModel: M
    var action: (Bool) -> Void
    
    private let spacing: CGFloat = 20
    private let padding: CGFloat = 50
    
    var body: some View {
        ZStack {
            Color.primaryCellBackground
            
            VStack(spacing: spacing) {
                Spacer()
                Image.Common.roundedAppIcon
                Text("child.shield.title")
                    .font(.appHeadingH2)
                    .foregroundColor(.primaryText)
                Text("child.shield.description")
                    .font(.appButton)
                    .foregroundColor(.primaryText).multilineTextAlignment(.center)
                Spacer()
                ConfirmButton(action: {
                    action(viewModel.isContentValid)
                }, title: viewModel.buttonTitle, isContentValid: $viewModel.isContentValid, isLoading: .constant(false))
            }.padding(padding)
        }
        .ignoresSafeArea()
    }
}

struct ShieldView_Previews: PreviewProvider {
    static var previews: some View {
        ShieldView(viewModel: MockQuestionsViewModel()) { _ in }
    }
}
