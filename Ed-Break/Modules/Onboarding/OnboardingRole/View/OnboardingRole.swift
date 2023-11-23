//
//  OnboardingRole.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 26.09.22.
//

import SwiftUI

struct OnboardingRole: View {
    
    @State private var showWebView = false
    @State private var isTermsSelected = true
    
    private let privacyUrl = URL(string: "https://ed-break.com/ed-break-terms-of-service/")!
    private let cellHeight = 214.0
    
    var body: some View {
        NavigationView {
            VStack {
                content
                Spacer()
                termsView
            }
            .background(Color.primaryBackground)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .foregroundColor(.appBlack)
        .accentColor(.appClear)
        .sheet(isPresented: $showWebView) {
            WebView(url: privacyUrl)
        }
    }
    
    
    // MARK: - Components
    
    private var content: some View {
        MainBackground(
            title: "onboarding.role",
            withNavbar: false
        ) {
            VStack(spacing: 19) {
                OnboardingRoleCell(role: .parent) {
                    if #available(iOS 16.0, *) {
                        ParentSignInView()
                    } else {
                        CreateOrJoinFamilyView()
                    }
                }
                .frame(height: cellHeight)
                .disabled(!isTermsSelected)
                
                OnboardingRoleCell(role: .child) {
                    ChildSignInView()
                }
                .frame(height: cellHeight)
                .disabled(!isTermsSelected)
            }
        }
    }
    
    private var termsView: some View {
        VStack {
            Text("onboarding.terms.text")
                .foregroundColor(.appWhite)
                .font(.appHeadline)
                .multilineTextAlignment(.center)
            Button {
                showWebView = true
            } label: {
                Text("onboarding.terms.action")
                    .foregroundColor(.appWhite)
                    .font(.appHeadline)
                    .underline()
            }
        }
        .padding(15)
    }
}

struct OnboardingRole_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingRole()
    }
}
