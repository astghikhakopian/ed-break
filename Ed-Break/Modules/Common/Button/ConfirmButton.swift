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
    @State var colorBackgroundValid: Color = .primaryPurple
    @State var colorBackgroundInvalid: Color = .border
    @State var colorTextValid: Color = .appWhite
    @State var colorTextInvalid: Color = .primaryDescription
    
    private let height = 54.0
    private let cornerRadius = 12.0
    
    var body: some View {
        ZStack {
            isContentValid ? colorBackgroundValid : colorBackgroundInvalid
            if !isLoading {
                Button(action: action, label: {
                    HStack {
                        Spacer()
                        Text(LocalizedStringKey(title))
                            .font(.appButton)
                        Spacer()
                    }
                })
                .foregroundColor( isContentValid ? colorTextValid  : colorTextInvalid )
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: colorTextValid))
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
