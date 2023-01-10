//
//  AnswerResultView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 20.11.22.
//

import SwiftUI

enum AnswerResultType {
    case success
    case failure
    
    var message: String {
        switch self {
        case .success: return "main.child.answer.success"
        case .failure: return "main.child.answer.failure"
        }
    }
    
    var image: Image {
        switch self {
        case .success: return .Common.Answer.success
        case .failure: return .Common.Answer.failure
        }
    }
    
    var color: Color {
        switch self {
        case .success: return .primaryGreen.opacity(0.9)
        case .failure: return .primaryRed.opacity(0.9)
        }
    }
}

struct AnswerResultView: View {
    let result: AnswerResultType
    
    private let spacing: CGFloat = 22
    private let width: CGFloat = 130
    
    var body: some View {
        ZStack {
            result.color
            
            VStack(spacing: spacing) {
                ZStack {
                    RoundedRectangle(cornerRadius: width/2)
                        .foregroundColor(Color.primaryCellBackground)
                        .frame(width: width, height: width)
                    result.image
                }
                Text(LocalizedStringKey(result.message))
                    .font(.appHeadingH3)
                    .foregroundColor(.primaryCellBackground)
            }
        }
        .ignoresSafeArea()
    }
}

struct AnswerResultView_Previews: PreviewProvider {
    static var previews: some View {
        AnswerResultView(result: .success)
    }
}
