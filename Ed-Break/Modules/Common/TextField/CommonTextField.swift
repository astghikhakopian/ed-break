//
//  CommonTextField.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.10.22.
//

import SwiftUI

struct CommonTextField: View {
    
    let title: String
    @Binding var text: String
    
    private let padding = EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20)
    private let cornerRadius = 12.0
    private let borderWidth = 1.0
    private let spacing = 0.0
    private let labelHeight = 30.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            Text(LocalizedStringKey(title))
                .font(.appHeadline)
                .frame(height: labelHeight)
                .foregroundColor(.primaryDescription)
            TextField("", text: $text)
                .font(.appHeadline)
                .padding(padding)
                .background(Color.appWhite)
                .accentColor(.primaryPurple)
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.border, lineWidth: borderWidth)
                )
        }
    }
}

struct CommonTextField_Previews: PreviewProvider {
    
    @State static var text = "Emma"
    
    static var previews: some View {
        CommonTextField(title: "Child name", text: $text)
    }
}
