//
//  ContentView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 26.09.22.
//

import SwiftUI
import FamilyControls

class AppState: ObservableObject {
    @Published var moveToDashboard: Bool = false
    @Published var moveToChildDashboard: Bool = false
    @Published var moveToLogin: Bool = false
    @Published var moveToChildQR: Bool = false
}

struct ContentView: View {
    
    @EnvironmentObject var appState: AppState
    @StateObject var model = DataModel.shared
    @State var isLoggedIn: Bool
    @State var isChildLoggedIn: Bool
    @State var waitingChild = false
    
    init() {
        let isLoggedIn: Bool? = UserDefaultsService().getPrimitive(forKey: .User.isLoggedIn)
        self.isLoggedIn = isLoggedIn ?? false
        
        let isChildLoggedIn: Bool? = UserDefaultsService().getPrimitive(forKey: .ChildUser.isLoggedIn)
        self.isChildLoggedIn = isChildLoggedIn ?? false
    }
    
    var body: some View {
        Group {
            if waitingChild {
                ChildQRView(viewModel: ChildQRViewModel(checkConnectionUseCase: CheckConnectionUseCase(childrenRepository: DefaultChildrenRepository()), localStorageService: UserDefaultsService()))
            } else {
                if isChildLoggedIn {
                    ChildTabView()
                        .environmentObject(model)
                } else if isLoggedIn {
                    TabBarView()
                        .environmentObject(model)
                } else {
                    OnboardingRole()
                }
            }
        }
        .onReceive(appState.$moveToDashboard) { moveToDashboard in
            guard moveToDashboard else { return }
            appState.moveToDashboard = false
            waitingChild = false
            isLoggedIn = true
        }
        .onReceive(appState.$moveToChildDashboard) { moveToChildDashboard in
            guard moveToChildDashboard else { return }
            appState.moveToChildDashboard = false
            waitingChild = false
            isChildLoggedIn = true
        }
        .onReceive(appState.$moveToLogin) { moveToLogin in
            guard moveToLogin else { return }
            appState.moveToLogin = false
            waitingChild = false
            isLoggedIn = false
            isChildLoggedIn = false
        }
        .onReceive(appState.$moveToChildQR) { moveToChildQR in
            guard moveToChildQR else { return }
            appState.moveToChildQR = false
            waitingChild = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
