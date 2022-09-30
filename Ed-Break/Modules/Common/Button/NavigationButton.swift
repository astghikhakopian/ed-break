//
//  NavigationButton.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 30.09.22.
//

import SwiftUI

struct NavigationButton<Content> : View where Content : View {
    let title: String
    @ViewBuilder let content: (() -> Content)
    
    @State private var selection: Int? = nil
    
    private let height = 54.0
    private let cornerRadius = 12.0
    
    var body: some View {
        NavigationLink(destination: content(), tag: 1, selection: $selection) {
            ZStack {
                Color.primary
                Button {
                    selection = 1
                } label: {
                    Text(LocalizedStringKey(title))
                        .font(.appButton)
                }
                .foregroundColor(.appWhite)
            }
            .frame(height: height)
            .cornerRadius(cornerRadius)
        }
    }
}

struct NavigationButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationButton(title: "Test") { }
    }
}
