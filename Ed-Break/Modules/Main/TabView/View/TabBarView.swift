//
//  TabBarView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 06.10.22.
//

import SwiftUI

struct TabBarView: View {
    
    @State private var selection = 0
    
    var body: some View {
        
        TabView(selection: $selection) {
            
            NavigationView {
                MainBackground(title: "onboarding.role", withNavbar: false) {
                    VStack(spacing: 30) {
                        OnboardingRoleCell(role: .parent) {
                            FamilySharingView(viewModel: FamilySharingViewModel(addParentUseCase: AddParentUseCase(familySharingRepository: DefaultFamilySharingRepository()), localStorageService: UserDefaultsService()))
                        }.frame(height: 150)
                        
                        OnboardingRoleCell(role: .child) {
                            // FamilySharing()
                        }.frame(height: 150)
                    }
                }
            }
            .foregroundColor(.appBlack)
            .accentColor(.appClear)
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag(0)
            
            
            NavigationView {
//            MainBackground(title: "Home", withNavbar: false) {
                
                    List(1...10, id: \.self) { index in
                        NavigationLink(
                            destination: Text("Item #\(index) Details"),
                            label: {
                                Text("Item #\(index)")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                            })
                        
//                    }
                }
            }
        
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(2)
                
                Text("Bookmark Tab")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .tabItem {
                        Image(systemName: "bookmark.circle.fill")
                        Text("Bookmark")
                    }
                    .tag(1)
                
            }
            .accentColor(.red)
            .onAppear() {
                UITabBar.appearance().barTintColor = .white
            }
//            .navigationBarTitle(Text(""), displayMode: .inline)
//        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
