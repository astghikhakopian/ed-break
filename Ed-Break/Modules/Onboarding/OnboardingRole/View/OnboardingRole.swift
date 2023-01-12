//
//  OnboardingRole.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 26.09.22.
//

import SwiftUI

struct OnboardingRole: View {
    
    @State private var showWebView = false
    @State private var isTermsSelected = false
    
    private let privacyUrl = URL(string: "https://docs.google.com/document/d/1STmonAdjpiDkjzC4ttS1SrYIJ-v2EAf7Hx8zK-3ACto")!
    private let cellHeight = 214.0
    private let spacing = 19.0
    
    var body: some View {
        NavigationView {
            VStack {
                MainBackground(title: "onboarding.role", withNavbar: false) {
                    VStack(spacing: spacing) {
                        OnboardingRoleCell(role: .parent) {
                            FamilySharingView(viewModel: FamilySharingViewModel(addParentUseCase: AddParentUseCase(familySharingRepository: DefaultFamilySharingRepository()), localStorageService: UserDefaultsService()))
                        }.frame(height: cellHeight)
                            .disabled(!isTermsSelected)
                        
                        OnboardingRoleCell(role: .child) {
                            ChildSignInView()
                        }.frame(height: cellHeight)
                            .disabled(!isTermsSelected)
                    }
                }
                Spacer()
                HStack(spacing: 12) {
                    Button {
                        isTermsSelected.toggle()
                    } label: {
                        Image.Common.checkmark
                            .renderingMode(.template)
                            .frame(width: 24, height: 24)
                            .foregroundColor(isTermsSelected ? Color.primaryPurple : .appWhite)
                            .background(Color.appWhite)
                            .cornerRadius(1)
                            .overlay(
                                RoundedRectangle(cornerRadius: 1)
                                    .stroke(isTermsSelected ? Color.primaryPurple : Color.primaryDescription, lineWidth: 1)
                            )
                    }
                    VStack(alignment: .leading) {
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
                }
            }.background(Color.primaryBackground)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .foregroundColor(.appBlack)
        .accentColor(.appClear)
        .sheet(isPresented: $showWebView) {
            WebView(url: privacyUrl)
        }
    }
}

struct OnboardingRole_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingRole()
    }
}
