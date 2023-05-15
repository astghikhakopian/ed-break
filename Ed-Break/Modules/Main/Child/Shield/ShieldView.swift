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
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
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
                .onReceive(timer) { time in
                    if viewModel.remindingSeconds > 0 {
//                        viewModel.remindingSeconds -= 1
                        var dt: Date = UserDefaultsService().getObject(forKey: .Time.last) ?? Date()
                        var passedSec = Date().timeIntervalSince(dt)
                        viewModel.remindingSeconds -= Int(round(passedSec))
                        UserDefaultsService().setObject(Date(), forKey: .Time.last)
                    }
                }
                .onAppear {
                    UserDefaultsService().remove(key: .Time.last)
                }
        }
        .ignoresSafeArea()
        .onAppear {
            viewModel.getQuestions()
        }
    }
}

struct ShieldView_Previews: PreviewProvider {
    static var previews: some View {
        ShieldView(viewModel: MockQuestionsViewModel()) { _ in }
    }
}
