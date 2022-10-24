//
//  ParentSettingsView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 24.10.22.
//

import SwiftUI

enum ParentSettingsCellType: CaseIterable {
    case childDevices, termsAndConditions, rateTheApp, deleteAccount
    
    var image: Image {
        switch self {
        case .childDevices:
            return .Settings.mobile
        case .termsAndConditions:
            return .Settings.asterisk
        case .rateTheApp:
            return .Settings.star
        case .deleteAccount:
            return .Settings.delete
        }
    }
    
    // "main.parent.settings.delete" = "Delete account";
    
    var title: String {
        switch self {
        case .childDevices:
            return "main.parent.settings.childDevices"
        case .termsAndConditions:
            return "main.parent.settings.termsAndConditions"
        case .rateTheApp:
            return "main.parent.settings.rateTheApp"
        case .deleteAccount:
            return "main.parent.settings.delete"
        }
    }
    
    var isMoreShown: Bool {
        switch self {
        case .childDevices: return true
        case .termsAndConditions, .rateTheApp, .deleteAccount: return false
        }
    }
    var isDeviderShown: Bool {
        switch self {
        case .childDevices, .termsAndConditions: return true
        case .rateTheApp, .deleteAccount: return false
        }
    }
}

struct ParentSettingsView: View {
    
    private let gap = 20.0
    private let spacing = 24.0
    private let itemSpacing = 12.0
    private let padding = 16.0
    private let cornerRadius = 12.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: gap) {
            
            ZStack(alignment: .leading) {
                Color.appWhite
                    .cornerRadius(cornerRadius)
                    .shadow(color: .shadow, radius: 40, x: 0, y: 20)
                
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(ParentSettingsCellType.allCases.filter{ $0 != .deleteAccount }, id: \.self) {
                        settingsCell(type: $0)
                    }
                }.padding(spacing)
            }
            
            settingsCell(type: .deleteAccount)
                .padding(spacing)
                .background(Color.appWhite)
                .cornerRadius(cornerRadius)
                .shadow(color: .shadow, radius: 40, x: 0, y: 20)
        }
    }
    
    func settingsCell(type: ParentSettingsCellType) -> some View {
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

struct ParentSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ParentSettingsView()
    }
}
