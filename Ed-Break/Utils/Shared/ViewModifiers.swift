//
//  ViewModifiers.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 09.11.22.
//

import SwiftUI

struct ViewDidLoadModifier: ViewModifier {

    @State private var didLoad = false
    private let action: (() -> Void)?

    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content.onAppear {
            if didLoad == false {
                didLoad = true
                action?()
            }
        }
    }
}

extension View {
    
    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }
}

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}


extension View {

    func answerResult(type: Binding<AnswerResultType?>) -> some View {
        return modifier(AnswerResultAlertModifier(type: type))
    }
}

struct AnswerResultAlertModifier {
    @Binding var type: AnswerResultType?
}

extension AnswerResultAlertModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if let type = type {
                AnswerResultView(result: type)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.type = nil
                        }
                    }
            }
        }
    }
}

