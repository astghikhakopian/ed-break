//
//  HomeView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.11.22.
//

import SwiftUI

struct HomeView<M: HomeViewModeling>: View {
    
    @StateObject private var viewModel = HomeViewModel(
        getSubjectsUseCase: GetSubjectsUseCase(
            childrenRepository: DefaultChildrenRepository()
        ),
        checkConnectionUseCase: CheckConnectionUseCase(
            childrenRepository: DefaultChildrenRepository()
        )
    )
    
    @State private var isShieldPresented = false
    @State private var isQuestionsActive = false
    
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
        .onReceive(
            NotificationCenter.default.publisher(
                for: UIApplication.didBecomeActiveNotification,
                object: nil
            ), perform: { _ in
                viewModel.getSubjects()
            }
        )
        .onChange(of: viewModel.shouldShowExercises) { shouldShowExercises in
            guard shouldShowExercises, !viewModel.isActiveWrongAnswersBlock else { return }
            isQuestionsActive = true
        }
        .overlay(
            NavigationLink(
                destination: subjectDestination(subject: viewModel.contentModel?.subjects.first ?? SubjectModel()),
                isActive: $isQuestionsActive) {
                    EmptyView()
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
            if viewModel.isActiveWrongAnswersBlock {
                Button(
                    action: { isShieldPresented = true },
                    label: { LessonCell(model: subject) }
                )
            } else {
                NavigationLink(
                    destination: { subjectDestination(subject: subject) },
                    label: {  LessonCell(model: subject) }
                )
            }
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
                    textToSpeachManager: DefaultTextToSpeachManager()
                )
            )
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
        ShieldView(remindingSeconds: $viewModel.shieldSeconds)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView<HomeViewModel>()
    }
}
