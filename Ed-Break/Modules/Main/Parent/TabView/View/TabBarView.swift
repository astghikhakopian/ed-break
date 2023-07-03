//
//  TabBarView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 06.10.22.
//

import SwiftUI

struct TabBarView: View {
    
    @StateObject var model = DataModel.shared
    
    @State private var selection = 0
    
    var body: some View {
        
        TabView(selection: $selection) {
            
            NavigationView {
                DashboardView(
                    viewModel: ChildrenViewModel(
                        filtered: true,
                        getChildrenUseCase: GetChildrenUseCase(
                            childrenRepository: DefaultChildrenRepository()),
                        pairChildUseCase: PairChildUseCase(
                            childrenRepository: DefaultChildrenRepository()),
                        refreshTokenUseCase: RefreshTokenUseCase(
                            familySharingRepository: DefaultFamilySharingRepository()), addRestrictionUseCase: AddRestrictionUseCase(restrictionsRepository: DefaultRestrictionsRepository())))
                .environmentObject(model)
                .showTabBar()
            }.navigationViewStyle(StackNavigationViewStyle())
            .foregroundColor(.appBlack)
            .accentColor(.appClear)
            .tabItem {
                if selection == 0 {
                    Image.TabView.Dashboard.selected
                } else {
                    Image.TabView.Dashboard.unselected
                }
                Text("tabbar.dashboard.title")
                    .font(.appBody)
            }
            .tag(0)
            
            
            NavigationView {
                MainBackground(title: "main.parent.coaching", withNavbar: false) {
                    CoachingView(
                        viewModel: CoachingViewModel(
                            getCoachingUseCase: GetCoachingUseCase(
                                childrenRepository: DefaultChildrenRepository()
                            )
                        )
                    )
                    .showTabBar()
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .foregroundColor(.appBlack)
            .accentColor(.appClear)
                .tabItem {
                    if selection == 1 {
                        Image.TabView.Coaching.selected
                    } else {
                        Image.TabView.Coaching.unselected
                    }
                    Text("tabbar.coaching.title")
                        .font(.appBody)
                }
                .tag(1)
            
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
                    ).showTabBar()
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                if selection == 2 {
                    Image.TabView.Settings.selected
                } else {
                    Image.TabView.Settings.unselected
                }
                Text("tabbar.settings.title")
                    .font(.appBody)
            }
            .tag(2)
            
        }
        .accentColor(.primaryPurple)
        .introspectTabBarController { (UITabBarController) in
            UITabBarController.tabBar.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
            UITabBarController.tabBar.layer.cornerRadius = 30
        }
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor.white
            UITabBar.appearance().layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
            UITabBar.appearance().layer.cornerRadius = 30
            UITabBar.appearance().clipsToBounds = true
            
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
