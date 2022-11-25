//
//  ChildSignInView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 20.10.22.
//

import SwiftUI
import FamilyControls

struct ChildSignInView: View {
    
    @EnvironmentObject var appState: AppState
    
    private let cornerRadius = 12.0
    private let padding = 36.0
    private let gap = 20.0
    
    var body: some View {
        
        MainBackground(title: "onboarding.childSignIn.title", withNavbar: true) {
            ZStack(alignment: .leading) {
                Color.appWhite
                    .cornerRadius(cornerRadius)
                    .shadow(color: .shadow, radius: 40, x: 0, y: 20)
                
                VStack(spacing: gap) {
                    Text("onboarding.childSignIn.description")
                        .font(.appHeadline)
                        .foregroundColor(.primaryText)
                        .multilineTextAlignment(.center)
                    CancelButton(action: {
                        AuthorizationCenter.shared.requestAuthorization { result in
                            switch result {
                            case .success:
                                DispatchQueue.main.async {
                                    appState.moveToChildQR = true
                                }
                            case .failure(let error):
                                print("Error for Family Controls: \(error)")
                            }
                        }

                    }, title: "onboarding.childSignIn.action", isContentValid: .constant(true))
                }.padding(padding)
            }
        }
    }
}

struct ChildSignInView_Previews: PreviewProvider {
    static var previews: some View {
        ChildSignInView()
    }
}
