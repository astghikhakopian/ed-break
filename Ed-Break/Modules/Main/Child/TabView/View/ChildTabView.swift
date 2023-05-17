//
//  ChildTabView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.11.22.
//

import SwiftUI

struct ChildTabView: View {
    
    @StateObject var model = DataModel.shared
    @EnvironmentObject var notificationManager: NotificationManager
    @State var isQuestions = false
    

    @State private var selection = 0
    
    var body: some View {
        
        TabView(selection: $selection) {
            
            NavigationView {
                MainBackground(title: "main.parent.home", withNavbar: false) {
                    HomeView(viewModel: HomeViewModel(
                        getSubjectsUseCase: GetSubjectsUseCase(
                            childrenRepository: DefaultChildrenRepository()
                        ),
                        checkConnectionUseCase: CheckConnectionUseCase(
                            childrenRepository: DefaultChildrenRepository()
                        )
                    ), isQuestns: $isQuestions)
                    .showTabBar()
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
                                parentRepository: DefaultParentRepository(
                                    plugins: [BasicAuthenticationPlugin()]
                                )
                            ),
                            localStorageService: UserDefaultsService()
                        )
                    )
                    .showTabBar()
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
        .accentColor(.primaryPurple)
        .introspectTabBarController { (UITabBarController) in
            UITabBarController.tabBar.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
            UITabBarController.tabBar.layer.cornerRadius = 30
        }
        .onChange(of: notificationManager.currentViewId) { viewId in
               guard let _ = viewId else { return }
              self.isQuestions = true
              selection = 0
           }
        .onReceive(.Push.doExercises, perform: { _ in
            self.isQuestions = true
            selection = 1
        })
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
