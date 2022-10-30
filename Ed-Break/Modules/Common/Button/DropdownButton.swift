//
//  DropdownButton.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 30.10.22.
//


import SwiftUI

struct DropdownButton: View {
    
    let title: String
    @Binding var grade: Grade
    var action: ()->()
    
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
                Button(action: action, label: {
                    HStack {
                        Text(grade.name)
                            .font(.appHeadline)
                            .background(Color.appWhite)
                            .accentColor(.primaryPurple)
                            .cornerRadius(cornerRadius)
                        Spacer()
                        Image.Common.dropdownArrow
                    }.padding(padding)
                        .overlay(
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .stroke(Color.border, lineWidth: borderWidth)
                        )
                })
        }
    }
}

struct DropdownButton_Previews: PreviewProvider {
    
    static var previews: some View {
        DropdownButton(title: "Child name", grade: .constant(Grade.first)) {}
    }
}
