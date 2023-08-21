//
//  ChildTabView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.11.22.
//

import SwiftUI
import CoreData

struct ChildTabView: View {
    
    @StateObject var model = DataModel.shared
    @StateObject private var offlineModeviewModel: OfflineChildSavingViewModel
    @State var isQuestions = false
    
    @State private var selection = 0
    
    private let persistenceController = PersistenceController.shared
    private let childProvider = OfflineChildProvideer(
        with: PersistenceController.shared.container,
        fetchedResultsControllerDelegate: nil
    )
    
    init() {
        let offlineModeviewModel =  OfflineChildSavingViewModel(
            getOfflineModeChildUseCase:
                GetOfflineModeChildUseCase(
                    offlineModeChildRepository: DefaultOfflineModeChildRepository()
                ),
            offlineChildProviderProtocol: childProvider,
            context: persistenceController.container.viewContext
        )
        
        self._offlineModeviewModel = StateObject(
            wrappedValue: offlineModeviewModel
        )
    }
    
    var body: some View {
        
        TabView(selection: $selection) {
            NavigationStackWrapper {
                MainBackground(title: "main.parent.home", withNavbar: false) {
                    HomeView<HomeViewModel, OfflineChildGettingViewModel>(
                        offlineChildProviderProtocol: childProvider,
                        context: persistenceController.container.viewContext
                    )
                    .showTabBar()
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
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor.white
            UITabBar.appearance().layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
            UITabBar.appearance().layer.cornerRadius = 30
            UITabBar.appearance().clipsToBounds = true
            
        }
        .onLoad {
            offlineModeviewModel.updateOfflineChild()
        }
        
    }
}

struct ChildTabView_Previews: PreviewProvider {
    static var previews: some View {
        ChildTabView()
    }
}
