//
//  ContentView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 26.09.22.
//

import SwiftUI


class AppState: ObservableObject {
    @Published var moveToDashboard: Bool = false
}

struct ContentView: View {
    
    @EnvironmentObject var appState: AppState
    @State var isLoggedIn: Bool
    
    init() {
        let isLoggedIn: Bool? = UserDefaultsService().getPrimitive(forKey: .User.isLoggedIn)
        self.isLoggedIn = isLoggedIn ?? true
    }
    
    var body: some View {
        Group {
            if isLoggedIn {
                TabBarView()
                
            } else {
                OnboardingRole()
            }
        }.onReceive(appState.$moveToDashboard) { moveToDashboard in
            guard moveToDashboard else { return }
            appState.moveToDashboard = false
            isLoggedIn = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
