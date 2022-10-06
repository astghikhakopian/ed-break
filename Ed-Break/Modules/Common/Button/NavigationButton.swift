//
//  NavigationButton.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 30.09.22.
//

import SwiftUI

struct NavigationButton<Content> : View where Content : View {
    let title: String
    var didTap: (() -> Void)? = nil
    @Binding var isContentValid: Bool
    @Binding var isLoading: Bool
    @ViewBuilder let content: (() -> Content)
    
    @State private var selection: Bool = false
    private var shouldTrackLoading: Bool
    private var shouldNavigateAfterLoading: Bool
    
    @State private var shouldTrackAction = false
    
    private let height = 54.0
    private let cornerRadius = 12.0
    
    init(
        title: String,
        didTap: ( () -> Void)? = nil,
        isContentValid: Binding<Bool>? = nil,
        isLoading: Binding<Bool>? = nil,
        shouldNavigateAfterLoading: Bool = false,
        content: @escaping () -> Content) {
            self.title = title
            self.didTap = didTap
            self._isContentValid = isContentValid ?? .constant(true)
            self._isLoading = isLoading ?? .constant(false)
            self.shouldNavigateAfterLoading = shouldNavigateAfterLoading
            self.content = content
            // self.selection = selection
            self.shouldTrackLoading = isLoading != nil
        }
    
    var body: some View {
        NavigationLink(destination: content(), isActive: $selection) {
            ZStack {
                Color.primaryPurple
                if !isLoading {
                    Button {
                        // guard shouldTrackAction else { shouldTrackAction = true; return }
                        if isContentValid {
                            didTap?()
                            if !shouldTrackLoading {
                                selection = true
                            }
                        }
                    } label: {
                        Text(LocalizedStringKey(title))
                            .font(.appButton)
                    }
                    .foregroundColor(.appWhite)
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .appWhite))
                }
            }
            .frame(height: height)
            .cornerRadius(cornerRadius)
        }.onChange(of: $isLoading.wrappedValue) { newValue in
            if newValue == false, shouldNavigateAfterLoading  {
                selection = true
            }
        }.onAppear {
            selection = false
        }
    }
}

struct NavigationButton_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationButton(title: "Test") { Text("") }
    }
}
