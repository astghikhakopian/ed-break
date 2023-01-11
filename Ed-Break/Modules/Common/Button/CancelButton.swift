//
//  CancelButton.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 30.09.22.
//

import SwiftUI

struct CancelButton: View {
    
    let action: () -> Void
    let title: String
    var color: Color = .appWhite
    @Binding var isContentValid: Bool
    
    private let height = 54.0
    private let cornerRadius = 12.0
    
    var body: some View {
        ZStack {
            //color.opacity(0.05)
            Button(action: action, label: {
                HStack {
                    Spacer()
                    Text(LocalizedStringKey(title))
                        .font(.appButton)
                    Spacer()
                }
            })
            .foregroundColor( isContentValid ? color : .primaryDescription )
        }
        .frame(height: height)
        .cornerRadius(cornerRadius)
    }
}

struct CancelButton_Previews: PreviewProvider {
    static var previews: some View {
        CancelButton(action: { }, title: "Test", isContentValid: .constant(true))
    }
}
