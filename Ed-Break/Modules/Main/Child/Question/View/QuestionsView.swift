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
    @State private var isAdditionalQuestions = false
    @State private var shouldShowContinueButton = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    private let padding: CGFloat = 30
    private let spacing: CGFloat = 12
    private let containerSpacing: CGFloat = 32
    private let cell: CGFloat = 50
    private let cellHeight: CGFloat = 50
    private let cellCornerRadius: CGFloat = 4
    private let indicatorCornerRadius: CGFloat = 4
    private let contentCornerRadius = 12.0
    private let indicatorHeight: CGFloat = 5
    private let indicatorSpacing: CGFloat = 8
    private let selectionHeight: CGFloat = 20
    
    var body: some View {
        MainBackground(
            title: viewModel.subject.title,
            withNavbar: true,
            isSimple: true,
            content: {
                VStack(spacing: containerSpacing) {
                    if viewModel.questionsContainer != nil {
                        pageIndicator
                        if viewModel.isPhoneUnlocked {
                            unlockedView
                        } else {
                            questionView
                            options
                        }
                    } else {
                        progressView
                    }
                }
            .padding(padding)
            .background(Color.primaryCellBackground)
            .cornerRadius(contentCornerRadius)
            .frame(
                minWidth: UIScreen.main.bounds.width - 2*padding,
                minHeight: UIScreen.main.bounds.height - 280
            )
            },
            stickyView: {
                if viewModel.isPhoneUnlocked {
                    return nil
                } else {
                    return AnyView(confirmButton)
                }
            }
        )
        .onLoad {
            viewModel.getQuestions()
            isAdditionalQuestions = false
        }
        /*
         .onChange(of: viewModel.currentQuestion, perform: { newValue in
         viewModel.textToSpeachManager.stop(at: .immediate)
         viewModel.textToSpeachManager.read(question: newValue, after: 0.3)
         })
         .onDisappear{
         viewModel.textToSpeachManager.stop(at: .immediate)
         }
         */
        .hiddenTabBar()
        .answerResult(
            type: $viewModel.answerResultType,
            isFeedbackGiven: $viewModel.isFeedbackGiven
        )
        .disabled(viewModel.isFeedbackGiven)
        
    }
}

extension QuestionsView {
    
    var unlockedView: some View {
        PhoneLockingStateView(
            state: .unlocked(
                time: DataModel.shared.remindingMinutes
            ),
            action: {
                presentationMode.wrappedValue.dismiss()
            },
            isLoading: $viewModel.isLoading,
            title: "common.continue"
        )
    }
    
    var progressView: some View {
        ProgressView()
            .progressViewStyle(
                CircularProgressViewStyle(tint: .primaryPurple)
            )
            .frame(
                width: UIScreen.main.bounds.width - 2 * padding,
                height: UIScreen.main.bounds.height - 200
            )
    }
    
    var pageIndicator: some View {
        HStack(spacing: indicatorSpacing) {
            ForEach(Array((viewModel.questionsContainer?.questions ?? []).enumerated()), id: \.1.uuid) { index, answer in
                Rectangle()
                    .foregroundColor(index < (viewModel.questionsContainer?.answeredQuestionsCount ?? 0) ? answer.isCorrect == true ? Color.primaryGreen : Color.primaryRed : Color.divader)
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
        Button(
            action: {
                selectedAnswer = model
                viewModel.isContentValid = true
            },
            label: {
                HStack(spacing: spacing) {
                    if !(viewModel.isFeedbackGiven) {
                        RoundedRectangle(cornerRadius: selectionHeight/2)
                            .stroke(isSelected ? Color.primaryPurple : Color.border, lineWidth: isSelected ? 7 : 1)
                            .frame(width: selectionHeight - (isSelected ? 7 : 1), height: selectionHeight - (isSelected ? 7 : 1))
                            .padding(.leading, (isSelected ? 3.5 : 0))
                            .padding(.trailing, (isSelected ? 2.5 : 0))
                    }
                    Text(model.answer ?? "")
                        .font(.appButton)
                        .foregroundColor(viewModel.isFeedbackGiven ? textColor(isSelected: isSelected, model: model)  : (isSelected ? Color.primaryPurple : Color.primaryText))
                    Spacer()
                }
                .padding()
                .background(viewModel.isFeedbackGiven ?  cellColor(isSelected: isSelected, model: model) : .primaryLightBackground)
                .cornerRadius(cellCornerRadius)
            })
    }
    
    var confirmButton: some View {
        ConfirmButton(
            action: {
                viewModel.textToSpeachManager.stop(at: .immediate)
                confirmSelectedAnswer()
            },
            title: viewModel.isLastQuestion ? "common.done" : "common.continue",
            isContentValid: $viewModel.isContentValid,
            isLoading: $viewModel.isLoading,
            colorBackgroundValid: .appWhite,
            colorTextValid: .primaryPurple
        )
        .disabled(!viewModel.isContentValid)
    }
    
    private func confirmSelectedAnswer() {
        guard let selectedAnswer = selectedAnswer else { return }
        viewModel.answerQuestion(answer: selectedAnswer, isAdditionalQuestions: isAdditionalQuestions) { _ in
            guard viewModel.currentQuestion.id == viewModel.questionsContainer?.questions.last?.id else { return }
            
            DispatchQueue.main.async {
                presentationMode.wrappedValue.dismiss()
                self.selectedAnswer = nil
            }
        }
    }
  
    private func cellColor(isSelected: Bool, model: QuestionAnswerModel) -> Color {
        isSelected ?
        model.correct ?
            .rightAnswer :
            .wrongAnswer
        :
        model.correct && (selectedAnswer != nil) ?
            .rightAnswer :
            .primaryLightBackground
    }
    
    private func textColor(isSelected: Bool, model: QuestionAnswerModel) -> Color {
        isSelected ?
        model.correct ?
            .primaryGreen :
            .primaryRed
        :
        model.correct && selectedAnswer != nil ?
            .primaryGreen :
            .primaryLightBackground
    }
}


// MARK: - Preview

struct QuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NavigationLazyView(
                QuestionsView(
                    viewModel: MockQuestionsViewModel()
                ).background(Color.primaryPurple)
            )
        }
    }
}
