//
//  ChildTabView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.11.22.
//

import SwiftUI

struct ChildTabView: View {
    
    @StateObject var model = DataModel.shared
//    @EnvironmentObject var model: DataModel
    @State private var uiTabarController: UITabBarController?
    @EnvironmentObject var notificationManager: NotificationManager
    @State var isQuestions = false
    @StateObject var homeViewModel = HomeViewModel(
        getSubjectsUseCase: GetSubjectsUseCase(
            childrenRepository: DefaultChildrenRepository()),
        checkConnectionUseCase: CheckConnectionUseCase(childrenRepository: DefaultChildrenRepository()))
    @State var subjectt: SubjectModel?
    

    @State private var selection = 0
    
    var body: some View {
        
        TabView(selection: $selection) {
            
            NavigationView {
                MainBackground(title: "main.parent.home", withNavbar: false) {
                    HomeView(viewModel: HomeViewModel(
                        getSubjectsUseCase: GetSubjectsUseCase(
                            childrenRepository: DefaultChildrenRepository()),
                        checkConnectionUseCase: CheckConnectionUseCase(childrenRepository: DefaultChildrenRepository())))
                    .environmentObject(model)
                    .environmentObject(notificationManager)
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .foregroundColor(.appBlack)
            .accentColor(.appClear)
            .tabItem {
                if selection == 0 {
                    Image.TabView.Home.selected
                } else {
                    Image.TabView.Home.unselected
                }
                Text("tabbar.home.title")
                    .font(.appBody)
            }
            .tag(0)
            
            NavigationView {
                MainBackground(title: "main.parent.settings", withNavbar: false) {
                    SettingsView(
                        viewModel: ParentSettingsViewModel(
                            deleteParentUseCase: DeleteParentUseCase(
                                parentRepository: DefaultParentRepository(plugins: [BasicAuthenticationPlugin()])),
                            localStorageService: UserDefaultsService()))
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                if selection == 1 {
                    Image.TabView.Settings.selected
                } else {
                    Image.TabView.Settings.unselected
                }
                Text("tabbar.settings.title")
                    .font(.appBody)
            }
            .tag(1)
            
        }
        .fullScreenCover(isPresented: $isQuestions.animation(.linear), content: {
                if let subject = subjectt {
                    NavigationLazyView(
                        QuestionsView(viewModel: QuestionsViewModel(subject: subject, home: homeViewModel.contentModel, getQuestionsUseCase: GetQuestionsUseCase(questionsRepository: DefaultQuestionsRepository()), answerQuestionUseCase: AnswerQuestionUseCase(questionsRepository: DefaultQuestionsRepository()), resultOfAdditionalQuestionsUseCase: ResultOfAdditionalQuestionsUseCase(questionsRepository: DefaultQuestionsRepository()))))
                }
            
            
    
           

        })
        .accentColor(.primaryPurple)
        .introspectTabBarController { (UITabBarController) in
            uiTabarController = UITabBarController
            UITabBarController.tabBar.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
            UITabBarController.tabBar.layer.cornerRadius = 30
        }
        .onChange(of: notificationManager.currentViewId) { viewId in
               guard let id = viewId else {
                   return
               }
            homeViewModel.getSubjects()
            
            let subjects = homeViewModel.contentModel?.subjects
            subjectt = SubjectModel()
            subjectt?.completedCount = Int.max
            for i in 0..<(subjects?.count ?? 0) {
                if !(subjects?[i].completed ?? false) {
                    if subjects![i].completedCount <= subjectt?.completedCount ?? Int.max {
                        self.subjectt = subjects?[i] ?? SubjectModel()
                    }
                }
            }
               let viewToShow = notificationManager.currentView(for: id)
                isQuestions = true
//               navStack.push(viewToShow)
           }
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor.white
            UITabBar.appearance().layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
            UITabBar.appearance().layer.cornerRadius = 30
            UITabBar.appearance().clipsToBounds = true
            
        }
        
    }
}

struct ChildTabView_Previews: PreviewProvider {
    static var previews: some View {
        ChildTabView()
    }
}
