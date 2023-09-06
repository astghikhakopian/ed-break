//
//  JoinFamilyView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 26.06.23.
//

import SwiftUI
import CodeScanner 

struct JoinFamilyView<M: FamilySharingViewModeling>: View {
    
    @ObservedObject var viewModel: M
    
    @EnvironmentObject var appState: AppState
    
    @State private var isShowingScanner: Bool = false
    @State private var contentSize: CGSize = .zero
    
    var body: some View {
        MainBackground(title: "onboarding.joinfamily.title", withNavbar: true, contentSize: $contentSize) {
            ZStack {
                ZStack(alignment: .bottom) {
                    VStack {
                        Text("onboarding.joinfamily.description")
                            .font(.appHeadline)
                            .foregroundColor(.appWhite)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                        Image.FamilySharing.addchildtofamily
                    }
                    LinearGradient(
                        gradient: Gradient(
                            colors: [.clear, .primaryPurple]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
//                    .frame(height: 300)
                }
                VStack(spacing: 0) {
                    Spacer()
                    ConfirmButton(
                        action: { isShowingScanner = true },
                        title: "onboarding.joinfamily.scanQR",
                        isContentValid: .constant(true),
                        isLoading: .constant(false),
                        colorBackgroundValid: .appWhite,
                        colorTextValid: .primaryPurple
                    )
                    NavigationSecondaryButton(
                        title: "onboarding.joinfamily.howTo") {
                            NewParentFamilySharingView(
                                viewModel: FamilySharingViewModel(
                                    addParentUseCase: AddParentUseCase(
                                        familySharingRepository: DefaultFamilySharingRepository()
                                    ),
                                    localStorageService: UserDefaultsService()
                                )
                            )
                        }
                }
            }
//            .frame(height: contentSize.height)
        }
        .sheet(isPresented: $isShowingScanner) {
            CodeScannerView(codeTypes: [.qr], completion: handleScan)
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
       isShowingScanner = false
        switch result {
        case .success(let info):
            let string = info.string
            guard
                let data = string.data(using: .utf8),
                let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any],
                let uuid = json["uuid"] as? String
                    
            else { return }
            viewModel.joinToFamily(familyOwnerDeviceToken: uuid) { success in
                guard success else { return }
                appState.moveToDashboard = true
            }
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
}

struct JoinFamilyView_Previews: PreviewProvider {
    static var previews: some View {
        JoinFamilyView(viewModel: MockFamilySharingViewModel())
    }
}
