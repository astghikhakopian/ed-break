//
//  ParentSettingsView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 24.10.22.
//

import SwiftUI
import StoreKit

struct ParentSettingsView<M: ParentSettingsViewModeling>: View {
    
    @ObservedObject var viewModel: M
    
    @EnvironmentObject var appState: AppState
    @Environment(\.openURL) private var openURL
    private let privacyUrl = URL(string: "https://pillow-talk.com.au/privacy-policy")!
    
    @State private var showDeleteOptions = false
    @State private var showWebView = false
    
    private let gap = 20.0
    private let spacing = 24.0
    private let itemSpacing = 12.0
    private let padding = 16.0
    private let cornerRadius = 12.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: gap) {
            mainContent
            deleteSection
        }.confirmationDialog(
            "main.parent.settings.delete",
            isPresented: $showDeleteOptions,
            titleVisibility: .visible) {
                Button("main.parent.settings.delete", role: .destructive) {
                    viewModel.deleteParent {
                        DispatchQueue.main.async {
                            appState.moveToLogin = true
                        }
                    }
                }
                Button("main.parent.settings.cancel", role: .cancel) {
                    showDeleteOptions = false
                }
            }
            .sheet(isPresented: $showWebView) {
                WebView(url: privacyUrl)
            }
    }
}


// MARK: - Components

extension ParentSettingsView {
    var mainContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            NavigationLink {
                ChildDevicesView(viewModel: ChildrenViewModel(getChildrenUseCase: GetChildrenUseCase(childrenRepository: DefaultChildrenRepository())))
            } label: {
                settingsCell(type: .childDevices).disabled(true)
            }
            settingsCell(type: .termsAndConditions) {
                showWebView = true
            }
            settingsCell(type: .rateTheApp) {
                guard let currentScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                SKStoreReviewController.requestReview(in: currentScene)
            }
        }.padding(spacing)
            .background(Color.appWhite)
            .cornerRadius(cornerRadius)
            .shadow(color: .shadow, radius: 40, x: 0, y: 20)
    }
    
    var deleteSection: some View {
        settingsCell(type: .deleteAccount, action: {
            showDeleteOptions = true
        }).padding(spacing)
            .background(Color.appWhite)
            .cornerRadius(cornerRadius)
            .shadow(color: .shadow, radius: 40, x: 0, y: 20)
    }
    
    func settingsCell(type: ParentSettingsCellType, action: (()->())? = nil) -> some View {
        Button {
            action?()
        } label: {
            VStack(spacing: 0) {
                HStack(spacing: itemSpacing) {
                    type.image
                    Text(LocalizedStringKey(type.title))
                        .font(.appButton)
                        .foregroundColor(.primaryDescription)
                    Spacer()
                    if type.isMoreShown {
                        Image.Settings.more
                    }
                }
                if type.isDeviderShown {
                    Divider().foregroundColor(Color.divader).padding(EdgeInsets(top: padding, leading: 0, bottom: padding, trailing: 0))
                }
            }
        }
    }
}


// MARK: - Preview

struct ParentSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ParentSettingsView(viewModel: MockParentSettingsViewModel())
    }
}
