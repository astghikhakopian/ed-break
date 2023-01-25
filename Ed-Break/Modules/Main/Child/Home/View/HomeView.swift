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
    
    private let progressWidth: CGFloat = 180
    private let textSpacing: CGFloat = 4
    private let headerPadding: CGFloat = 35
    private let headerHeight: CGFloat = 30
    private let cornerRadius = 12.0
    
    private let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
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
                NavigationLink {
                    NavigationLazyView(
                            QuestionsView(
                                viewModel: QuestionsViewModel(
                                    subject: subject,
                                    home: viewModel.contentModel,
                                    getQuestionsUseCase: GetQuestionsUseCase(
                                        questionsRepository: DefaultQuestionsRepository()),
                                    answerQuestionUseCase: AnswerQuestionUseCase(
                                        questionsRepository: DefaultQuestionsRepository()),
                                    resultOfAdditionalQuestionsUseCase: ResultOfAdditionalQuestionsUseCase(
                                        questionsRepository: DefaultQuestionsRepository()))))
                } label: {
                    LessonCell(model: subject)
                }.disabled(viewModel.contentModel?.wrongAnswersTime ?? Date().toLocalTime() > Date().toLocalTime())
            }
        }.onTapGesture {
            if viewModel.contentModel?.wrongAnswersTime ?? Date().toLocalTime() > Date().toLocalTime() {
                isShieldPresented = true
            }
        }
        .onReceive(timer) { time in
            if viewModel.remindingMinutes > 0 {
                viewModel.remindingMinutes -= 1
                DataModel.shared.remindingMinutes = viewModel.remindingMinutes
            } else {
                DataModel.shared.remindingMinutes = 0
                viewModel.setRestrictions()
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
                questionsRepository: DefaultQuestionsRepository()))) { _ in
                    isShieldPresented = false
                }
        }
        
//        .onLoad {
//            viewModel.getSubjects()
//        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: MockHomeViewModel())
    }
}
