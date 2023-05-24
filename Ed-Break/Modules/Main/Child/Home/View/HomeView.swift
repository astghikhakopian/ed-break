//
//  HomeView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.11.22.
//

import SwiftUI

struct HomeView<M: HomeViewModeling>: View {
    
    @StateObject var viewModel: M
    
    @State private var isShieldPresented = false
    @State private var isQuestions = false

    private let progressWidth: CGFloat = 180
    private let textSpacing: CGFloat = 4
    private let spacing: CGFloat = 12
    private let headerPadding: CGFloat = 35
    private let headerHeight: CGFloat = 30
    private let cornerRadius = 12.0
    
    
    var body: some View {
        VStack(spacing: spacing) {
            progressView
            subjects
        }
        .onAppear {
          viewModel.getSubjects()
        }
        .onReceive(.Push.notif, perform: { _ in
            // TODO: - Mekhak - viewmodel-i mej // vontsvor nuin bann a grats. kara function lini
            if !(viewModel.contentModel?.wrongAnswersTime ?? Date().toLocalTime() > Date().toLocalTime()) {
                isQuestions = true
            } else {
                isShieldPresented = true
            }
        })
        .onTapGesture {
            // TODO: - Mekhak - viewmodel-i mej // vontsvor nuin bann a grats. kara function lini
            if viewModel.contentModel?.wrongAnswersTime ?? Date().toLocalTime() > Date().toLocalTime() {
                isShieldPresented = true
            }
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: UIApplication.didBecomeActiveNotification,
                object: nil
            ), perform: { _ in
                viewModel.getSubjects()
            }
        )
        .fullScreenCover(
            isPresented: $isShieldPresented,
            content: { shield }
        )
    }
    
    // MARK: - Components
    
    private var subjects: some View {
        ForEach(viewModel.contentModel?.subjects ?? [], id: \.id) { subject in
            NavigationLink(
                destination: { subjectDestination(subject: subject) },
                label: { LessonCell(model: subject) }
            )
            .disabled(viewModel.contentModel?.wrongAnswersTime ?? Date().toLocalTime() > Date().toLocalTime())
        }
    }
    
    private func subjectDestination(subject: SubjectModel) -> some View {
        NavigationLazyView(
            QuestionsView(
                viewModel: QuestionsViewModel(
                    subject: subject,
                    home: viewModel.contentModel,
                    getQuestionsUseCase: GetQuestionsUseCase(
                        questionsRepository: DefaultQuestionsRepository()
                    ),
                    answerQuestionUseCase: AnswerQuestionUseCase(
                        questionsRepository: DefaultQuestionsRepository()
                    ),
                    resultOfAdditionalQuestionsUseCase: ResultOfAdditionalQuestionsUseCase(
                        questionsRepository: DefaultQuestionsRepository()
                    ),
                    textToSpeachManager: DefaultTextToSpeachManager()
                )
            )
        )
    }
    
    private func subjectItemView(subject: SubjectModel) -> some View {
        Button(
            action: {
                // TODO: - Mekhak - viewmodel-i mej
                if !(viewModel.contentModel?.wrongAnswersTime ?? Date().toLocalTime() > Date().toLocalTime()) {
                    isQuestions = true
                } else {
                    isShieldPresented = true
                }
            },
            label: {
                LessonCell(model: subject)
            }
        )
    }
    
    private var progressView: some View {
        HStack {
            Spacer()
            progressViewContent
            Spacer()
        }
        .background(Color.primaryCellBackground)
            .cornerRadius(cornerRadius)
    }
    
    private var progressViewContent: some View {
        ZStack {
            progressViewContentText
            CircularProgressView(progress: viewModel.progress)
                .frame(height: progressWidth)
        }.padding(headerPadding)
    }
    
    private var progressViewContentText: some View {
        VStack(spacing: textSpacing) {
            HStack(alignment: .bottom, spacing: textSpacing) {
                Text(String(viewModel.remindingMinutes))
                    .font(.appHeadingH2)
                    .foregroundColor(.primaryPurple)
                Text("main.child.home.min")
                    .font(.appHeadline)
                    .foregroundColor(.primaryPurple)
                    .frame(height: headerHeight)
            }
            Text("main.child.home.usage")
                .font(.appBody)
                .foregroundColor(.primaryDescription)
                .multilineTextAlignment(.center)
        }
    }
    
    private var shield: some View {
        ShieldView<QuestionsViewModel>(
            viewModel: QuestionsViewModel(
                subject: SubjectModel(),
                home: viewModel.contentModel,
                getQuestionsUseCase: GetQuestionsUseCase(
                    questionsRepository: DefaultQuestionsRepository()),
                answerQuestionUseCase: AnswerQuestionUseCase(
                    questionsRepository: DefaultQuestionsRepository()),
                resultOfAdditionalQuestionsUseCase: ResultOfAdditionalQuestionsUseCase(
                    questionsRepository: DefaultQuestionsRepository()),
                textToSpeachManager: DefaultTextToSpeachManager()
            )
        ) { _ in isShieldPresented = false }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: MockHomeViewModel())
    }
}
