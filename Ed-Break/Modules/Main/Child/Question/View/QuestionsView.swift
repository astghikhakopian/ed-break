//
//  QuestionsView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 14.11.22.
//

import SwiftUI

struct QuestionsView<M: QuestionsViewModeling>: View {
    
    @StateObject var viewModel: M
    
    @State private var selectedAnswer: QuestionAnswerModel?
    @State private var uiTabarController: UITabBarController?
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    private let padding: CGFloat = 20
    private let spacing: CGFloat = 12
    private let containerSpacing: CGFloat = 32
    private let cell: CGFloat = 50
    private let cellHeight: CGFloat = 50
    private let cellCornerRadius: CGFloat = 4
    private let indicatorCornerRadius: CGFloat = 4
    private let indicatorHeight: CGFloat = 5
    private let indicatorSpacing: CGFloat = 8
    private let selectionHeight: CGFloat = 20
    
    var body: some View {
        VStack(spacing: containerSpacing) {
            if let questionsContainer = viewModel.questionsContainer {
                pageIndicator
                if questionsContainer.answeredCount >= questionsContainer.questions.count {
                    PhoneLockingStateView(state: .locked, action: {
                        // TODO: -
                        presentationMode.wrappedValue.dismiss()
                    }, isLoading: $viewModel.isLoading)
                } else {
                    questionView
                    options
                    confirmButton
                }
            }
        }.padding(padding)
            .background(Color.appWhite)
            .onLoad {
                viewModel.getQuestions()
            }
            .introspectTabBarController { (UITabBarController) in
                UITabBarController.tabBar.isHidden = true
                uiTabarController = UITabBarController
            }.onDisappear{
                uiTabarController?.tabBar.isHidden = false
            }
            .answerResult(type: $viewModel.answerResultType)
    }
}

extension QuestionsView {
    
    var pageIndicator: some View {
        HStack(spacing: indicatorSpacing) {
            ForEach(Array((viewModel.questionsContainer?.questions ?? []).enumerated()), id: \.1.id) { index, answer in
                Rectangle()
                    .foregroundColor(index < (viewModel.questionsContainer?.answeredCount ?? 0) ?/* answer.questionAnswer == true ? Color.primaryGreen :*/  Color.primaryRed : Color.divader)
                    .frame(height: indicatorHeight)
                    .cornerRadius(indicatorCornerRadius)
            }
        }
    }
    
    var questionView: some View {
        VStack {
            Spacer()
            Text(viewModel.currentQuestion.questionText ?? "")
                .font(.appHeadingH3)
                .foregroundColor(Color.primaryText)
            Spacer()
        }
    }
    
    var options: some View {
        VStack(spacing: spacing) {
            ForEach(viewModel.currentQuestion.questionAnswer, id: \.id) {
                answerCell(model: $0, isSelected: selectedAnswer?.id == $0.id)
            }
        }
    }
    
    func answerCell(model: QuestionAnswerModel, isSelected: Bool) -> some View {
        Button(action: {
            selectedAnswer = model
        }, label: {
            HStack(spacing: spacing) {
                RoundedRectangle(cornerRadius: selectionHeight/2)
                    .stroke(isSelected ? Color.primaryPurple : Color.border, lineWidth: isSelected ? 7 : 1)
                    .frame(width: selectionHeight - (isSelected ? 7 : 1), height: selectionHeight - (isSelected ? 7 : 1))
                    .padding(.leading, (isSelected ? 3.5 : 0))
                    .padding(.trailing, (isSelected ? 2.5 : 0))
                Text(model.answer ?? "")
                    .font(.appButton)
                    .foregroundColor(isSelected ? Color.primaryPurple : Color.primaryText)
                Spacer()
            }
            .padding()
            .background(Color.primaryLightBackground)
            .cornerRadius(cellCornerRadius)
        })
    }
    
    var confirmButton: some View {
        ConfirmButton(action: {
            guard let selectedAnswer = selectedAnswer else { return }
            viewModel.answerQuestion(answer: selectedAnswer) { _ in
                presentationMode.wrappedValue.dismiss()
            }
        }, title: "common.continue", isLoading: $viewModel.isLoading)
    }
}

//struct QuestionsView_Previews: PreviewProvider {
//    static var previews: some View {
//        QuestionsView()
//    }
//}
