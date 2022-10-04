//
//  QRCodeView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 03.10.22.
//

import SwiftUI

struct QRCodeView: View {
    
    @State private var isContentValid = true
    
    private let cornerRadius = 12.0
    private let spacing = 10.0
    private let padding = 36.0
    private let gap = 20.0
    
    var body: some View {
        MainBackground(title: "onboarding.qrCode.title", withNavbar: true) {
            VStack(spacing: gap) {
                content
                NavigationButton(
                    title: "common.continue",
                    didTap: { },
                    content: {
                        ChildrenView(
                            viewModel: ChildrenViewModel(
                                getChildrenUseCase: GetChildrenUseCase(
                                    childrenRepository: DefaultChildrenRepository(
                                        plugins: [BasicAuthenticationPlugin()])))) })
            }
        }
    }
}

private extension QRCodeView {
    
    var content: some View {
        ZStack(alignment: .leading) {
            Color.appWhite
                .cornerRadius(cornerRadius)
                .shadow(color: .shadow, radius: 40, x: 0, y: 20)
            VStack(spacing: spacing) {
                Image.QRCode.qrCode
                Text("qrCode.description")
                    .font(.appHeadline)
                    .foregroundColor(.primaryText)
                    .multilineTextAlignment(.center)
            }.padding(padding)
        }
    }
}

struct QRCodeView_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeView()
    }
}
