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
    
    var body: some View {
        
        MainBackground(
            title: "onboarding.parentSignIn.title",
            withNavbar: true
        ) {
            ZStack(alignment: .leading) {
                navigationDestination
                mainBackground
                content
            }
            .alert(
                "common.error",
                isPresented: $isAlertPresenting, actions: { },
                message: { Text(error?.localizedDescription ?? "") }
            )
        }
    }
}


// MARK: - Components

extension ParentSignInView {
    
    private var content: some View {
        VStack(spacing: 20) {
            Text("onboarding.parentSignIn.description")
                .font(.appHeadline)
                .foregroundColor(.primaryText)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            ZStack {
                Color.primaryPurple.opacity(0.05)
                confirmButton
            }
            .cornerRadius(cornerRadius)
        }.padding(36)
    }
    
    private var confirmButton: some View {
        CancelButton(
            action: {
                Task {
                    if #available(iOS 16.0, *) {
                        do {
                            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                            self.moveForward()
                        } catch {
                            self.showError(error)
                        }
                    } else {
                        AuthorizationCenter.shared.requestAuthorization { result in
                            switch result {
                            case .success:
                                self.moveForward()
                            case .failure(let error):
                                self.showError(error)
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
    
    private var navigationDestination: some View {
        NavigationLink(
            destination: CreateOrJoinFamilyView(),
            isActive: $isMovingForward
        ) { EmptyView() }
    }
    
    private var mainBackground: some View {
        Color.primaryCellBackground
            .cornerRadius(cornerRadius)
            .shadow(color: .shadow, radius: 40, x: 0, y: 20)
    }
    
    private func moveForward() {
        DispatchQueue.main.async {
            isMovingForward = true
        }
    }
    
    private func showError(_ error: Error) {
        self.error = error
        self.isAlertPresenting = true
        print("Error for Family Controls: \(error)")
    }
}

struct ParentSignInView_Previews: PreviewProvider {
    static var previews: some View {
        ParentSignInView()
    }
}
