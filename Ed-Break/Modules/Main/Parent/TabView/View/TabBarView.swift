//
//  TabBarView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 06.10.22.
//

import SwiftUI

struct TabBarView: View {
    
    @EnvironmentObject var model: DataModel
    
    @State private var selection = 0
    
    var body: some View {
        
        TabView(selection: $selection) {
            
            NavigationView {
                MainBackground(title: "main.parent.home", withNavbar: false) {
                    HomeView(viewModel: ChildrenViewModel(getChildrenUseCase: GetChildrenUseCase(childrenRepository: DefaultChildrenRepository())))
                        .environmentObject(model)
                }
            }
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
            
            
            Spacer()
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
                    ParentSettingsView(
                        viewModel: ParentSettingsViewModel(
                            deleteParentUseCase: DeleteParentUseCase(
                                parentRepository: DefaultParentRepository(plugins: [BasicAuthenticationPlugin()])),
                            localStorageService: UserDefaultsService()))
                }
            }
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
        .onAppear { UITabBar.appearance().backgroundColor = UIColor.white }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
