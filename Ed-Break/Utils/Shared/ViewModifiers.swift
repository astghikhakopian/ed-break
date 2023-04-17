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

    func answerResult(type: Binding<AnswerResultType?>, isFeedbackGiven: Binding<Bool?>) -> some View {
        return modifier(AnswerResultAlertModifier(type: type, isFeegbackGiven: isFeedbackGiven))
    }
}

struct AnswerResultAlertModifier {
    @Binding var type: AnswerResultType?
    @Binding var isFeegbackGiven: Bool?
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
                            self.isFeegbackGiven = true
                        }
                    }
            }
        }
    }
}



extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
