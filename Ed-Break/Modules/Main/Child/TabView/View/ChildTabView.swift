//
//  ChildTabView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.11.22.
//

import SwiftUI

struct ChildTabView: View {
    
    @EnvironmentObject var model: DataModel
    
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
        .accentColor(.primaryPurple)
        .onAppear { UITabBar.appearance().backgroundColor = UIColor.white }
    }
}

struct ChildTabView_Previews: PreviewProvider {
    static var previews: some View {
        ChildTabView()
    }
}