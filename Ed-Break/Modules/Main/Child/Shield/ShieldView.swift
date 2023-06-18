//
//  ShieldView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 08.12.22.
//

import SwiftUI

struct ShieldView: View {
    
//    @Binding var isActiveWrongAnswersBlock: Bool
//    let wrongAnswersTime: Date
    @Binding  var remindingSeconds: Int
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    var action: (Bool) -> Void
        
//    init(
//        isActiveWrongAnswersBlock: Binding<Bool>,
//        wrongAnswersTime: Date,
//        action: @escaping (Bool) -> Void
//    ) {
//        self._isActiveWrongAnswersBlock = isActiveWrongAnswersBlock
//        self.wrongAnswersTime = wrongAnswersTime
//        self.action = action
        
//        if let difference = self.getSeconds(start: wrongAnswersTime),
//           difference < 0 {
//            self.remindingSeconds = -difference
//            self.updateButtonState()
//        }
//    }
    
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
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
//    private func updateButtonState() {
//        guard remindingSeconds >= 0 else { buttonTitle = "common.continue"; return }
//            if remindingSeconds == 0 {
//                buttonTitle = "Back to subjects"
//                isContentValid = true
//            } else {
//                let seconds = (remindingSeconds % 3600) % 60
//                let minutes = ((remindingSeconds % 3600) / 60)
//                let secondsString = seconds <= 9 ? "0\(seconds)" : "\(seconds)"
//                buttonTitle = "\(minutes):\(secondsString)"
//                isContentValid = false
//            }
//    }
    
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
//                    action(isContentValid)
                }, title: buttonTitle, isContentValid: $isContentValid, isLoading: .constant(false))
            }.padding(padding)
                
        }
        .ignoresSafeArea()
//        .onAppear {
            // viewModel.getQuestions()
//        }
//        .onReceive(timer) { time in
//            isActiveWrongAnswersBlock = remindingSeconds > 0
//            if remindingSeconds > 0 {
//                remindingSeconds -= 1
//                updateButtonState()
////                        let dt: Date = UserDefaultsService().getObject(forKey: .Time.last) ?? Date()
////                        let passedSec = Date().timeIntervalSince(dt)
////                        viewModel.remindingSeconds -= Int(round(passedSec))
////                        UserDefaultsService().setObject(Date(), forKey: .Time.last)
//            }
//        }
//        .onAppear {
//                    UserDefaultsService().remove(key: .Time.last)
//        }
    }
    
//    private func getSeconds(start: Date?) -> Int? {
//        guard let start = start else { return nil }
//        let diff = Int(Date().toLocalTime().timeIntervalSince1970 - start.timeIntervalSince1970)
//
//        let hours = diff / 3600
//        let minutes = (diff - hours * 3600)
//        return minutes
//    }
}

//struct ShieldView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShieldView(viewModel: MockQuestionsViewModel(), isActiveWrongAnswersBlock: .constant(false)) { _ in }
//    }
//}
