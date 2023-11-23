//
//  ShieldView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 08.12.22.
//

import SwiftUI

struct ShieldView: View {
    
    @Binding  var remindingSeconds: Int
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.scenePhase) var scenePhase
    
    @State private var isContentValid: Bool = true
    
    var buttonTitle: String  {
        guard remindingSeconds >= 0 else { return "common.continue" }
        if remindingSeconds == 0 {
            return "Back to subjects"
        } else {
            let seconds = (remindingSeconds % 3600) % 60
            let minutes = ((remindingSeconds % 3600) / 60)
            let secondsString = seconds <= 9 ? "0\(seconds)" : "\(seconds)"
            return "\(minutes):\(secondsString)"
        }
    }
    
    private let spacing: CGFloat = 20
    private let padding: CGFloat = 50
    
    var body: some View {
        ZStack {
            Color.primaryCellBackground
            
            VStack(spacing: spacing) {
                Spacer()
                Image.Common.roundedAppIcon
                Text("child.shield.title")
                    .font(.appHeadingH2)
                    .foregroundColor(.primaryText)
                Text("child.shield.description")
                    .font(.appButton)
                    .foregroundColor(.primaryText).multilineTextAlignment(.center)
                Spacer()
                ConfirmButton(action: {
                    presentationMode.wrappedValue.dismiss()
                }, title: buttonTitle, isContentValid: $isContentValid, isLoading: .constant(false))
            }.padding(padding)
            
        }
        .ignoresSafeArea()
        .onChange(of: scenePhase) { newPhase in
            guard newPhase == .inactive else { return }
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct BlockShieldView: View {
    
    @Binding var error: QuestionBlockError?
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.scenePhase) var scenePhase
    
    @State private var isContentValid: Bool = true
    
    var buttonTitle: String  {
        let time = error?.blockedTime ?? 0
        guard time >= 0 else { return "common.continue" }
        if time == 0 {
            return "Back to subjects"
        } else {
            let seconds = (time % 3600) % 60
            let minutes = ((time % 3600) / 60)
            let secondsString = seconds <= 9 ? "0\(seconds)" : "\(seconds)"
            return "\(minutes):\(secondsString)"
        }
    }
    
    private let spacing: CGFloat = 20
    private let padding: CGFloat = 50
    
    var body: some View {
        ZStack {
            Color.primaryCellBackground
            
            VStack(spacing: spacing) {
                Spacer()
                Image.Common.roundedAppIcon
                Text("child.shield.title")
                    .font(.appHeadingH2)
                    .foregroundColor(.primaryText)
                Text(error?.errorMessage ?? "child.shield.description")
                    .font(.appButton)
                    .foregroundColor(.primaryText).multilineTextAlignment(.center)
                Spacer()
                ConfirmButton(action: {
                    presentationMode.wrappedValue.dismiss()
                }, title: buttonTitle, isContentValid: $isContentValid, isLoading: .constant(false))
            }
            .padding(padding)
        }
        .ignoresSafeArea()
        .onChange(of: scenePhase) { newPhase in
            guard newPhase == .inactive else { return }
            presentationMode.wrappedValue.dismiss()
        }
    }
}
