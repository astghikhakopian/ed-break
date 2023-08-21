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
    
    private let privacyUrl = URL(string: "https://docs.google.com/document/d/1STmonAdjpiDkjzC4ttS1SrYIJ-v2EAf7Hx8zK-3ACto")!
    private let cellHeight = 214.0
    private let spacing = 19.0
    
    var body: some View {
        NavigationView {
            VStack {
                MainBackground(title: "onboarding.role", withNavbar: false) {
                    VStack(spacing: spacing) {
                        OnboardingRoleCell(role: .parent) {
                            CreateOrJoinFamilyView()
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
                Spacer()
                // HStack(spacing: 12) {
                    /*
                    Button {
                        isTermsSelected.toggle()
                    } label: {
                        Image.Common.checkmark
                            .renderingMode(.template)
                            .frame(width: 24, height: 24)
                            .foregroundColor(isTermsSelected ? Color.primaryPurple : .appWhite)
                            .background(Color.appWhite)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(isTermsSelected ? Color.primaryPurple : Color.primaryDescription, lineWidth: 1)
                            )
                    }
                    */
                    VStack {
                        Text("onboarding.terms.text")
                            .foregroundColor(.appWhite)
                            .font(.appHeadline)
                            .multilineTextAlignment(.leading)
                        Button {
                            showWebView = true
                        } label: {
                            Text("onboarding.terms.action")
                                .foregroundColor(.appWhite)
                                .font(.appHeadline)
                                .underline()
                        }
                    }.padding(15)
                // }
            }.background(Color.primaryBackground)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .foregroundColor(.appBlack)
        .accentColor(.appClear)
        .sheet(isPresented: $showWebView) {
            WebView(url: privacyUrl)
        }
        .onAppear {
//            let token = TokenModel(
//                refresh: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY5MjA5MDU2NSwiaWF0IjoxNjg5NDk4NTY1LCJqdGkiOiI3ZDAwOTk3MDg5NDA0YmQyYjM0NjFjZWFhM2ZjNGVlNyIsInVzZXJfaWQiOjEzNTl9.87UjV32rudLGkm4cYv-c5V1Exgj24JJP8smdj-NTXZo",
//                access: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjkyMDkwNTY1LCJpYXQiOjE2ODk0OTg1NjUsImp0aSI6IjQ4YjBlODI5ZWI3MTQxNGI5MzJjMTcxMDM1YzBjMTE0IiwidXNlcl9pZCI6MTM1OX0.g-A_36ZJS5mWPAmnCQAjsPK6F9JK-fuiZI7AXcnpe1s")
//            UserDefaultsService().setObject(token, forKey: .ChildUser.token)
//            UserDefaultsService().setPrimitive(true, forKey: .ChildUser.isLoggedIn)
        }
    }
}

struct OnboardingRole_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingRole()
    }
}
