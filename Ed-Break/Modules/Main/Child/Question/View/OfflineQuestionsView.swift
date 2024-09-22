//
//  OfflineQuestionsView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 16.08.23.
//

import SwiftUI

struct OfflineQuestionsView<
    M: OfflineChildQuestionViewModeling,
    N: ReadQuestionViewModeling
>: View {
    
    @StateObject var viewModel: M
    @StateObject var readQuestionViewModel: N
    
    @State private var selectedAnswer: OfflineQuestionAnswerModel?
    @State private var shouldShowContinueButton = false
    @State private var contentSize: CGSize = .zero
    
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        MainBackground(
            title: viewModel.subject?.subject ?? "",
            withNavbar: true,
            isSimple: true,
            contentSize: $contentSize,
            content: {
                VStack(spacing: 32) {
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
            .padding(30)
            .background(Color.primaryCellBackground)
            .cornerRadius(12)
            .frame(width: UIScreen.main.bounds.width - 30)
            .frame(minHeight: contentSize.height)
            },
            stickyView: {
                if viewModel.isPhoneUnlocked {
                    return nil
                } else {
                    return AnyView(confirmButton)
                }
            },
            leftBarButtonItem: {
                return viewModel.isPhoneUnlocked ? nil : AnyView(voiceButton)
            }
        )
        .onLoad {
            viewModel.getQuestions()
        }
        .hiddenTabBar()
        .answerResult(
            type: $viewModel.answerResultType,
            isFeedbackGiven: $viewModel.isFeedbackGiven
        )
        .onChange(of: networkMonitor.isConnected, perform: { newValue in
            DispatchQueue.main.async {
                presentationMode.wrappedValue.dismiss()
            }
        })
        .disabled(viewModel.isFeedbackGiven)
        
    }
}

extension OfflineQuestionsView {
    
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
                width: UIScreen.main.bounds.width - 2 * 30,
                height: contentSize.height
            )
    }
    
    var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(Array((viewModel.questionsContainer?.questions ?? []).enumerated()), id: \.1.id) { index, answer in
                Rectangle()
                    .foregroundColor(index < (viewModel.questionsContainer?.answeredQuestionsCount ?? 0) ? answer.isCorrect == true ? Color.primaryGreen : Color.primaryRed : Color.divader)
                    .frame(height: 5)
                    .cornerRadius(4)
            }
        }
    }
    
    var questionView: some View {
        VStack {
            Spacer()
            Text(viewModel.currentQuestion?.questionText ?? "")
                .font(.appHeadingH3)
                .foregroundColor(Color.primaryText)
                .padding(.horizontal, 8)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(readQuestionViewModel.currentReadingItem == .question ? .blue : .clear, lineWidth: 1)
        )
    }
    
    var options: some View {
        VStack(spacing: 12) {
            ForEach(viewModel.currentQuestion?.answers ?? [], id: \.id) { answer in
                answerCell(
                    model: answer,
                    isSelected: selectedAnswer?.id == answer.id,
                    isCurrentReading: readQuestionViewModel.isCurrentReading(
                        currentQuestion: viewModel.currentQuestion,
                        answer: answer
                    )
                )
            }
        }
    }
    
    func answerCell(model: OfflineQuestionAnswerModel, isSelected: Bool, isCurrentReading: Bool) -> some View {
        Button(
            action: {
                selectedAnswer = model
                viewModel.isContentValid = true
            },
            label: {
                HStack(alignment: .top, spacing: 12) {
                    if !viewModel.isFeedbackGiven {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isSelected ? Color.primaryPurple : Color.border, lineWidth: isSelected ? 7 : 1)
                            .frame(width: 20 - (isSelected ? 7 : 1), height: 20 - (isSelected ? 7 : 1))
                            .padding(.leading, (isSelected ? 3.5 : 0))
                            .padding(.trailing, (isSelected ? 2.5 : 0))
                            .padding(.top, (isSelected ? 2.5 : 0))
                    }
                    Text(model.answer)
                        .font(.appButton)
                        .foregroundColor(viewModel.isFeedbackGiven ? textColor(isSelected: isSelected, model: model)  : (isSelected ? Color.primaryPurple : Color.primaryText))
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                .padding()
                .background(viewModel.isFeedbackGiven ?  cellColor(isSelected: isSelected, model: model) : .primaryLightBackground)
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isCurrentReading ? .blue : .clear, lineWidth: 1)
                )
                
            })
    }
    
    var confirmButton: some View {
        ConfirmButton(
            action: {
                readQuestionViewModel.stopPlayingQuestion()
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
    
    var voiceButton: some View {
        Button {
            guard !viewModel.isPhoneUnlocked,
                  let currentQuestion = viewModel.currentQuestion
            else { return }
            readQuestionViewModel.startPlayingQuestion(currentQuestion: currentQuestion)
        } label: { Image.ChildHome.volume }
    }
    
    private func confirmSelectedAnswer() {
        guard let selectedAnswer = selectedAnswer else { return }
        viewModel.answerQuestion(answer: selectedAnswer) { _ in
            guard viewModel.currentQuestion?.id == viewModel.questionsContainer?.questions.last?.id else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                presentationMode.wrappedValue.dismiss()
                self.selectedAnswer = nil
            }
        }
    }
  
    private func cellColor(isSelected: Bool, model: OfflineQuestionAnswerModel) -> Color {
        isSelected ?
        model.correct ?
            .rightAnswer :
            .wrongAnswer
        :
        model.correct && (selectedAnswer != nil) ?
            .rightAnswer :
            .primaryLightBackground
    }
    
    private func textColor(isSelected: Bool, model: OfflineQuestionAnswerModel) -> Color {
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

struct OfflineQuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NavigationLazyView(
                OfflineQuestionsView(
                    viewModel: MockOfflineChildQuestionViewModel(),
                    readQuestionViewModel: MockReadQuestionViewModel()
                )
                .background(Color.primaryPurple)
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
