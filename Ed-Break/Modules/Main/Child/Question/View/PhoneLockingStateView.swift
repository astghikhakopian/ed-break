//
//  PhoneLockingStateView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 20.11.22.
//

import SwiftUI
import Foundation

enum PhoneLockingState {
    case locked
    case unlocked(time: Int)
    
    var message: String {
        switch self {
        case .locked: return "main.child.lockstate.locked"
        case .unlocked: return "main.child.lockstate.unlocked"
        }
    }
    var description: String {
        switch self {
        case .locked: return "main.child.lockstate.locked.description"
        case .unlocked:
            return "main.child.lockstate.unlocked.description %@"
        }
    }
    
    var image: Image {
        switch self {
        case .locked: return .ChildHome.LockState.locked
        case .unlocked: return .ChildHome.LockState.unlocked
        }
    }
}

struct PhoneLockingStateView: View {
    
    let state: PhoneLockingState
    let action: () -> Void
    
    @Binding var isLoading: Bool
    var title: String

    
    private let spacing: CGFloat = 8
    private let padding: CGFloat = 20
    private let width: CGFloat = 110
    private let cornerreadius:CGFloat = 12
    
    var body: some View {
        VStack(spacing: spacing) {
            ZStack {
                RoundedRectangle(cornerRadius: width/2)
                    .foregroundColor(Color.primaryLightBackground)
                    .frame(width: width, height: width)
                state.image
            }
            Text(LocalizedStringKey(state.message))
                .font(.appHeadingH3)
                .foregroundColor(.primaryText)
            switch state {
            case .locked:
                Text(LocalizedStringKey(state.description))
                    .font(.appHeadline)
                    .foregroundColor(.primaryDescription)
                    .padding(padding)
                    .multilineTextAlignment(.center)
            case .unlocked(time: let time):
                Text(String(
                    format: NSLocalizedString(state.description, comment: ""),
                    arguments: [String(time)]
                ))
                .font(.appHeadline)
                .foregroundColor(.primaryDescription)
                .padding(padding)
                .multilineTextAlignment(.center)
            }
             
            Spacer()
            confirmButton
        }
    }
    
    var confirmButton: some View {
            ConfirmButton(action: action, title: title, isContentValid: .constant(true), isLoading: $isLoading)
        }
    }


struct PhoneLockingStateView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneLockingStateView(state: .unlocked(time: 15), action: {}, isLoading: .constant(false), title: "common.continue")
    }
}
