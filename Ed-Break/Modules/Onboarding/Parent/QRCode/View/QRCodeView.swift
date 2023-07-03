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
        MainBackground(title: "", withNavbar: true,hideBackButton: true) {
            VStack(spacing: gap) {
                content
                NavigationButton(
                    title: "common.continue",
                    didTap: { },
                    shouldNavigateAfterLoading: true,
                    content: {
                        ChildrenView(
                            viewModel: ChildrenViewModel(
                                filtered: false,
                                getChildrenUseCase: GetChildrenUseCase(
                                    childrenRepository: DefaultChildrenRepository(
                                        plugins: [BasicAuthenticationPlugin()])),
                                pairChildUseCase: PairChildUseCase(childrenRepository: DefaultChildrenRepository(
                                    plugins: [BasicAuthenticationPlugin()])), refreshTokenUseCase: RefreshTokenUseCase(familySharingRepository: DefaultFamilySharingRepository()), addRestrictionUseCase: AddRestrictionUseCase(restrictionsRepository: DefaultRestrictionsRepository())
                            ))})
            }
        }.navigationBarBackButtonHidden()
    }
}

private extension QRCodeView {
    
    var content: some View {
        ZStack(alignment: .leading) {
            Color.primaryCellBackground
                .cornerRadius(cornerRadius)
                .shadow(color: .shadow, radius: 40, x: 0, y: 20)
            HStack {
                Spacer()
                VStack(spacing: spacing) {
                    Image.QRCode.qrCode.resizable().frame(width: 200, height: 200)
                    Text("qrCode.description")
                        .font(.appHeadline)
                        .foregroundColor(.primaryText)
                        .multilineTextAlignment(.center)
                }.padding(padding)
                Spacer()
            }
        }
    }
}

struct QRCodeView_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeView()
    }
}
