//
//  ParentSignInView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 23.08.23.
//

import SwiftUI
import FamilyControls

struct ParentSignInView: View {
    
    @State private var isMovingForward = false
    
    @State private var error: Error? = nil
    @State private var isAlertPresenting: Bool = false
    
    private let cornerRadius = 12.0
    private let padding = 36.0
    private let gap = 20.0
    
    var body: some View {
        
        MainBackground(
            title: "onboarding.parentSignIn.title",
            withNavbar: true
        ) {
            ZStack(alignment: .leading) {
                NavigationLink(destination: CreateOrJoinFamilyView(), isActive: $isMovingForward) { EmptyView() }
                Color.primaryCellBackground
                    .cornerRadius(cornerRadius)
                    .shadow(color: .shadow, radius: 40, x: 0, y: 20)
                
                VStack(spacing: gap) {
                    Text("onboarding.parentSignIn.description")
                        .font(.appHeadline)
                        .foregroundColor(.primaryText)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    ZStack {
                        Color.primaryPurple.opacity(0.05)
                        CancelButton(action: {
                            
                            Task {
                                if #available(iOS 16.0, *) {
                                    do {
                                        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                                        DispatchQueue.main.async {
                                            isMovingForward = true
                                        }
                                    } catch {
                                        print("Failed... \(error)")
                                        self.error = error
                                        self.isAlertPresenting = true
                                    }
                                } else {
                                    AuthorizationCenter.shared.requestAuthorization { result in
                                        switch result {
                                        case .success:
                                            DispatchQueue.main.async {
                                                isMovingForward = true
                                            }
                                        case .failure(let error):
                                            self.error = error
                                            self.isAlertPresenting = true
                                            print("Error for Family Controls: \(error)")
                                            
                                        }
                                    }
                                }
                            }
                        },
                                     title: "onboarding.parentSignIn.action",
                                     color: .primaryPurple,
                                     isContentValid: .constant(true)
                        )
                    }
                    .cornerRadius(cornerRadius)
                }.padding(padding)
            }
            .alert(
                "common.error",
                isPresented: $isAlertPresenting, actions: { },
                message: { Text(error?.localizedDescription ?? "") }
            )
        }
    }
}

struct ParentSignInView_Previews: PreviewProvider {
    static var previews: some View {
        ParentSignInView()
    }
}
