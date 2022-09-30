//
//  ConfirmButton.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 30.09.22.
//

import SwiftUI

struct ConfirmButton: View {
    
    let action: () -> Void
    let title: String
    
    private let height = 54.0
    private let cornerRadius = 12.0
    
    var body: some View {
        ZStack {
            Color.primary
            Button(action: action, label: {
                Text(LocalizedStringKey(title))
                    .font(.appButton)
            })
            .foregroundColor(.appWhite)
        }
        .frame(height: height)
        .cornerRadius(cornerRadius)
    }
}

struct ConfirmButton_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmButton(action: { }, title: "Test")
    }
}
