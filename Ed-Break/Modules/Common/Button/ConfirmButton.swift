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
    
    @Binding var isContentValid: Bool
    @Binding var isLoading: Bool
    
    private let height = 54.0
    private let cornerRadius = 12.0
    
    var body: some View {
        ZStack {
            isContentValid ? Color.white : Color.border
            if !isLoading {
                Button(action: action, label: {
                    HStack {
                        Spacer()
                        Text(LocalizedStringKey(title))
                            .font(.appButton)
                        Spacer()
                    }
                })
                .foregroundColor( isContentValid ? .primaryPurple : .primaryDescription )
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .appWhite))
            }
        }
        .frame(height: height)
        .cornerRadius(cornerRadius)
    }
}

struct ConfirmButton_Previews: PreviewProvider {
    
    @State static var isLoading = false
    
    static var previews: some View {
        ConfirmButton(action: { }, title: "Test", isContentValid: .constant(true), isLoading: $isLoading)
    }
}
