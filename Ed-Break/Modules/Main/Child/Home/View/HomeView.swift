//
//  HomeView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.11.22.
//

import SwiftUI
import CoreData

struct HomeView<M: HomeViewModeling, N: OfflineChildGettingViewModeling>: View {
    
    @StateObject private var viewModel: M
    @StateObject private var offlineChildGettingViewModel: N
    
    @State private var isShieldPresented = false
    @State private var isQuestionsActive = false
    
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    
    private let offlineChildProviderProtocol: OfflineChildProvideerProtocol
    private let context: NSManagedObjectContext
    
    private let progressWidth: CGFloat = 180
    private let textSpacing: CGFloat = 4
    private let spacing: CGFloat = 12
    private let headerPadding: CGFloat = 35
    private let headerHeight: CGFloat = 30
    private let cornerRadius = 12.0
    
    init(
        offlineChildProviderProtocol: OfflineChildProvideerProtocol,
        context: NSManagedObjectContext
    ) {
        self.offlineChildProviderProtocol = offlineChildProviderProtocol
        self.context = context
        _viewModel = StateObject(
            wrappedValue:
                HomeViewModel(
                    getSubjectsUseCase: GetSubjectsUseCase(
                        childrenRepository: DefaultChildrenRepository()
                    ),
                    checkConnectionUseCase: CheckConnectionUseCase(
                        childrenRepository: DefaultChildrenRepository()
                    )
                ) as! M)
        
        _offlineChildGettingViewModel = StateObject(
            wrappedValue: OfflineChildGettingViewModel(
                offlineChildProviderProtocol: offlineChildProviderProtocol,
                context: context
            ) as! N
        )
    }
    
    var body: some View {
        VStack(spacing: spacing) {
            progressView
            if networkMonitor.isConnected {
                remoteSubjects
            } else {
                localSubjects
            }
        }
        .onAppear {
            if networkMonitor.isConnected {
                viewModel.getSubjects()
            } else {
                offlineChildGettingViewModel.getSubjects()
            }
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: UIApplication.didBecomeActiveNotification,
                object: nil
            ), perform: { _ in
                if networkMonitor.isConnected {
                    viewModel.getSubjects()
                } else {
                    offlineChildGettingViewModel.getSubjects()
                }
            }
        )
        .onChange(of: viewModel.shouldShowExercises) { shouldShowExercises in
            guard shouldShowExercises, !viewModel.isActiveWrongAnswersBlock, !isQuestionsActive else { return }
            isQuestionsActive = true
        }
        .onChange(of: networkMonitor.isConnected) { isConnected in
            if isConnected {
                viewModel.getSubjects()
            } else {
                offlineChildGettingViewModel.getSubjects()
            }
        }
        .overlay(
            NavigationLink(
                destination: subjectDestination(
                    subject: viewModel.contentModel?.subjects.randomElement() ?? SubjectModel(),
                    offlineSubject: offlineChildGettingViewModel.contentModel?.childSubjects.randomElement()
                ),
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
    
    private var remoteSubjects: some View {
        ForEach(viewModel.contentModel?.subjects ?? [], id: \.id) { subject in
            if viewModel.isActiveWrongAnswersBlock {
                Button(
                    action: { isShieldPresented = true },
                    label: { LessonCell(model: subject) }
                )
            } else {
                NavigationLink(
                    destination: { subjectDestination(
                        subject: subject,
                        offlineSubject: nil
                    ) },
                    label: {  LessonCell(model: subject) }
                )
            }
        }
    }
    
    private var localSubjects: some View {
        ForEach(offlineChildGettingViewModel.contentModel?.childSubjects ?? [], id: \.id) { offlineSubjectModel in
            let subject = SubjectModel(offlineSubjectModel: offlineSubjectModel)
            return NavigationLink(
                destination: { subjectDestination(
                    subject: subject,
                    offlineSubject: offlineSubjectModel
                )
                },
                label: {  LessonCell(model: subject) }
            )
        }
    }
    
    private func subjectDestination(
        subject: SubjectModel,
        offlineSubject: OfflineSubjectModel?
    ) -> some View {
        if networkMonitor.isConnected {
            return AnyView(
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
                            )
                        ),
                        readQuestionViewModel: ReadQuestionViewModel(
                            textToSpeachManager: DefaultTextToSpeachManager.sharedInstance
                        )
                    )
                )
            )
        } else {
            return AnyView (
                NavigationLazyView(
                    OfflineQuestionsView(
                        viewModel: OfflineChildQuestionViewModel(
                            subject: offlineSubject,
                            contentModel: offlineChildGettingViewModel.contentModel,
                            updateBreakDateOfflineChildUseCase: UpdateBreakDateOfflineChildUseCase(
                                offlineChildProvider: offlineChildProviderProtocol
                            ),
                            context: context
                        ),
                        readQuestionViewModel: ReadQuestionViewModel(
                            textToSpeachManager: DefaultTextToSpeachManager.sharedInstance
                        )
                    )
                )
            )
        }
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
