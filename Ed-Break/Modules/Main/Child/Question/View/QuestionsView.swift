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
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        MainBackground(
            title: viewModel.subject.title,
            withNavbar: true,
            isSimple: true,
            stickyView:
                (viewModel.questionsContainer?.answeredCount ?? 0) < (viewModel.questionsContainer?.questions.count ?? 0)
            ? confirmButton : nil
        ) {
            VStack(spacing: containerSpacing) {
                if let questionsContainer = viewModel.questionsContainer {
                    pageIndicator
                    if questionsContainer.answeredCount >= questionsContainer.questions.count {
                        if DataModel.shared.selectionToDiscourage.applicationTokens.isEmpty &&
                            DataModel.shared.selectionToDiscourage.applications.isEmpty &&
                            DataModel.shared.selectionToDiscourage.categories.isEmpty &&
                            DataModel.shared.selectionToDiscourage.categoryTokens.isEmpty {
                            PhoneLockingStateView(state: .unlocked, action: {
                                presentationMode.wrappedValue.dismiss()
                            }, isLoading: $viewModel.isLoading, title: "common.continue")
                        } else {
                            PhoneLockingStateView(state: .locked, action: {
//                                guard viewModel.remindingMinutes > 0 else {
//                                    DispatchQueue.main.async {
//                                        viewModel.getAdditionalQuestions()
////                                        presentationMode.wrappedValue.dismiss()
//                                    }
//                                    return }
                                viewModel.getAdditionalQuestions()
                                isAdditionalQuestions = true
                            }, isLoading: $viewModel.isLoading, title: viewModel.remindingSeconds < 0 ? "common.continue" : viewModel.buttonTitle)
                        }
                        /*
                        if questionsContainer.questions.filter { $0.isCorrect ?? false }.count == questionsContainer.questions.count {
                            PhoneLockingStateView(state: .unlocked, action: {
                                if isAdditionalQuestions {
                                    viewModel.didAnswerAdditionalQuestions {
                                        DispatchQueue.main.async {
                                            presentationMode.wrappedValue.dismiss()
                                        }
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                }
                            }, isLoading: $viewModel.isLoading, title: viewModel.buttonTitle)
                        } else {
                            PhoneLockingStateView(state: .locked, action: {
                                guard viewModel.remindingMinutes <= 0 else { return }
                                viewModel.getAdditionalQuestions()
                                isAdditionalQuestions = true
                            }, isLoading: $viewModel.isLoading, title: viewModel.buttonTitle)
                        }
                         */
                    } else {
                        questionView
                        options
                       // confirmButton
                    }
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .primaryPurple))
                        .frame(width: UIScreen.main.bounds.width - 2*padding, height: UIScreen.main.bounds.height - 200)
                }
            }.padding(padding)
                .background(Color.primaryCellBackground)
                .cornerRadius(contentCornerRadius)
                //.frame(minWidth: UIScreen.main.bounds.width - 2*padding, minHeight: UIScreen.main.bounds.height - 150)
                .onReceive(timer) { time in
                    if viewModel.remindingSeconds > 0 {
                        viewModel.remindingSeconds -= 1
                    }
                }
        }
            .onLoad {
                viewModel.getQuestions()
            }
            .onChange(of: viewModel.currentQuestion, perform: { newValue in
                viewModel.textToSpeachManager.stop(at: .immediate)
                viewModel.textToSpeachManager.read(question: newValue, after: 0.3)
            })
            .onDisappear{
                viewModel.textToSpeachManager.stop(at: .immediate)
            }
            .hiddenTabBar()
            .answerResult(type: $viewModel.answerResultType,isFeedbackGiven: $viewModel.isFeedbackGiven)
            .disabled(viewModel.isFeedbackGiven ?? false)
            
    }
}

extension QuestionsView {
    
    var pageIndicator: some View {
        HStack(spacing: indicatorSpacing) {
            ForEach(Array((viewModel.questionsContainer?.questions ?? []).enumerated()), id: \.1.id) { index, answer in
                Rectangle()
                    .foregroundColor(index < (viewModel.questionsContainer?.answeredCount ?? 0) ? answer.isCorrect == true ? Color.primaryGreen : Color.primaryRed : Color.divader)
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
                if !(viewModel.isFeedbackGiven ?? false) {
                    RoundedRectangle(cornerRadius: selectionHeight/2)
                        .stroke(isSelected ? Color.primaryPurple : Color.border, lineWidth: isSelected ? 7 : 1)
                        .frame(width: selectionHeight - (isSelected ? 7 : 1), height: selectionHeight - (isSelected ? 7 : 1))
                        .padding(.leading, (isSelected ? 3.5 : 0))
                        .padding(.trailing, (isSelected ? 2.5 : 0))
                }
                Text(model.answer ?? "")
                    .font(.appButton)
                    .foregroundColor(viewModel.isFeedbackGiven ?? false ? textColor(isSelected: isSelected, model: model)  : (isSelected ? Color.primaryPurple : Color.primaryText))
                Spacer()
            }
            .padding()
            .background(viewModel.isFeedbackGiven ?? false ?  cellColor(isSelected: isSelected, model: model) : .primaryLightBackground)
            //.background(isSelected ? ( model.correct ? Color.green : Color.red) : .primaryLightBackground)
            .cornerRadius(cellCornerRadius)
        })
    }
    
    var confirmButton: some View {
        ConfirmButton(action: {
            viewModel.textToSpeachManager.stop(at: .immediate)
            guard let selectedAnswer = selectedAnswer else { return }
            viewModel.answerQuestion(answer: selectedAnswer) { _ in
                guard viewModel.currentQuestion.id == viewModel.questionsContainer?.questions.last?.id else { return }
                if isAdditionalQuestions {
                    viewModel.didAnswerAdditionalQuestions {
                        DispatchQueue.main.async {
                            presentationMode.wrappedValue.dismiss()
                            self.selectedAnswer = nil
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        presentationMode.wrappedValue.dismiss()
                        self.selectedAnswer = nil
                    }
                }
            }
          
        }, title: "common.continue", isContentValid: .constant(true), isLoading: $viewModel.isLoading,colorBackgroundValid: .white,colorTextValid: .primaryPurple).disabled(viewModel.remindingSeconds > 0)
    }
    
    private func cellColor(isSelected: Bool, model: QuestionAnswerModel) -> Color {
        if isSelected {
            if model.correct {
                    return Color.rightAnswer
            } else {
                return Color.wrongAnswer
            }
        } else {
            if model.correct && (selectedAnswer != nil) {
                return Color.rightAnswer
            } else {
                return Color.primaryLightBackground
            }
          //  return Color.primaryLightBackground
        }
    }
    
    private func textColor(isSelected: Bool, model: QuestionAnswerModel) -> Color {
        if isSelected {
            if model.correct {
                    return Color.primaryGreen
            } else {
                return Color.primaryRed
            }
        } else {
            if model.correct && (selectedAnswer != nil) {
                return Color.primaryGreen
            } else {
                return Color.primaryLightBackground
            }
          //  return Color.primaryLightBackground
        }
    }
    
}

struct QuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NavigationLazyView(
                    QuestionsView(
                        viewModel: MockQuestionsViewModel())
                    .background(Color.primaryPurple)
                )}
    }
}
