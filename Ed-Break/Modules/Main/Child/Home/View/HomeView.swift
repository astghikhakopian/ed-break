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
    @EnvironmentObject var notificationManager: NotificationManager
    @State var isNot: Bool = false
    @State var isQuestions = false

    private let progressWidth: CGFloat = 180
    private let textSpacing: CGFloat = 4
    private let headerPadding: CGFloat = 35
    private let headerHeight: CGFloat = 30
    private let cornerRadius = 12.0
    
    @State var isQuestns: Binding<Bool> = .constant(false)
    @State var isFromNotif: Binding<Bool> = .constant(false)
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Spacer()
                
                ZStack {
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
                    
                    CircularProgressView(progress: viewModel.progress)
                        .frame(height: progressWidth)
                }.padding(headerPadding)
                Spacer()
            }.background(Color.primaryCellBackground)
                .cornerRadius(cornerRadius)
            ForEach(viewModel.contentModel?.subjects ?? [], id: \.id) { subject in
                
                NavigationLink(destination: NavigationLazyView(QuestionsView(
                    viewModel: QuestionsViewModel(
                        subject: subject,
                        home: viewModel.contentModel,
                        getQuestionsUseCase: GetQuestionsUseCase(
                            questionsRepository: DefaultQuestionsRepository()),
                        answerQuestionUseCase: AnswerQuestionUseCase(
                            questionsRepository: DefaultQuestionsRepository()),
                        resultOfAdditionalQuestionsUseCase: ResultOfAdditionalQuestionsUseCase(
                            questionsRepository: DefaultQuestionsRepository()), textToSpeachManager: DefaultTextToSpeachManager()))), isActive: $isQuestions) {
                                Button {
                                    if !(viewModel.contentModel?.wrongAnswersTime ?? Date().toLocalTime() > Date().toLocalTime()) {
                                        isQuestions = true
                                    } else {
                                        isShieldPresented = true
                                    }
                                } label: {
                                    LessonCell(model: subject)
//                                    NavigationLink("", destination: NavigationLazyView(  QuestionsView(
//                                        viewModel: QuestionsViewModel(
//                                            subject: subject,
//                                            home: viewModel.contentModel,
//                                            getQuestionsUseCase: GetQuestionsUseCase(
//                                                questionsRepository: DefaultQuestionsRepository()),
//                                            answerQuestionUseCase: AnswerQuestionUseCase(
//                                                questionsRepository: DefaultQuestionsRepository()),
//                                            resultOfAdditionalQuestionsUseCase: ResultOfAdditionalQuestionsUseCase(
//                                                questionsRepository: DefaultQuestionsRepository()), textToSpeachManager: DefaultTextToSpeachManager()))),isActive: $isQuestions)
                                }
                            }
//                NavigationLink {
//                            QuestionsView(
//                                viewModel: QuestionsViewModel(
//                                    subject: subject,
//                                    home: viewModel.contentModel,
//                                    getQuestionsUseCase: GetQuestionsUseCase(
//                                        questionsRepository: DefaultQuestionsRepository()),
//                                    answerQuestionUseCase: AnswerQuestionUseCase(
//                                        questionsRepository: DefaultQuestionsRepository()),
//                                    resultOfAdditionalQuestionsUseCase: ResultOfAdditionalQuestionsUseCase(
//                                        questionsRepository: DefaultQuestionsRepository()), textToSpeachManager: DefaultTextToSpeachManager()))
//                } label: {
//                    LessonCell(model: subject)
//                    NavigationLink("", destination: NavigationLazyView(  QuestionsView(
//                        viewModel: QuestionsViewModel(
//                            subject: subject,
//                            home: viewModel.contentModel,
//                            getQuestionsUseCase: GetQuestionsUseCase(
//                                questionsRepository: DefaultQuestionsRepository()),
//                            answerQuestionUseCase: AnswerQuestionUseCase(
//                                questionsRepository: DefaultQuestionsRepository()),
//                            resultOfAdditionalQuestionsUseCase: ResultOfAdditionalQuestionsUseCase(
//                                questionsRepository: DefaultQuestionsRepository()), textToSpeachManager: DefaultTextToSpeachManager()))),isActive: isQuestns)
//                }.disabled(viewModel.isNavigationAllowed)
            }
        }
        .onReceive(.Push.notif, perform: { _ in
            if !(viewModel.contentModel?.wrongAnswersTime ?? Date().toLocalTime() > Date().toLocalTime()) {
//                isQuestns = .constant(true)
                isQuestions = true
            } else {
                isShieldPresented = true
            }
        })
        .onTapGesture {
            if viewModel.contentModel?.wrongAnswersTime ?? Date().toLocalTime() > Date().toLocalTime() {
                isShieldPresented = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification, object: nil)) { _ in
            viewModel.getSubjects()
        }
        .onAppear {
            viewModel.getSubjects()
        }
        .fullScreenCover(isPresented: $isShieldPresented) { ShieldView<QuestionsViewModel>(viewModel: QuestionsViewModel(
            subject: SubjectModel(),
            home: viewModel.contentModel,
            getQuestionsUseCase: GetQuestionsUseCase(
                questionsRepository: DefaultQuestionsRepository()),
            answerQuestionUseCase: AnswerQuestionUseCase(
                questionsRepository: DefaultQuestionsRepository()),
            resultOfAdditionalQuestionsUseCase: ResultOfAdditionalQuestionsUseCase(
                questionsRepository: DefaultQuestionsRepository()), textToSpeachManager: DefaultTextToSpeachManager())) { _ in
                    isShieldPresented = false
                }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: MockHomeViewModel())
    }
}
