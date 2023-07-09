//
//  NewParentFamilySharingView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 26.06.23.
//

import SwiftUI
import CodeScanner

struct NewParentFamilySharingView<M: FamilySharingViewModeling>: View {
    
    @ObservedObject var viewModel: M
    
    @Environment(\.openURL) private var openURL
    @EnvironmentObject var appState: AppState
    @State private var isShowingScanner: Bool = false
    @State private var contentSize: CGSize = .zero
    
    private let cells: [FamilySharingCellType] = [.appleFamily, .waitForInvite, .confirmInvite, .returnBack]
    private let cornerRadius = 12.0
    private let gap = 20.0
    private let spacing = 25.0
    private let settingsUrl = URL(string: UIApplication.openSettingsURLString)!
    
    var body: some View {
        MainBackground(title: "onboarding.familySharing.title", withNavbar: true, contentSize: $contentSize) {
            VStack(spacing: gap) {
                steps
                info
                Spacer().frame(maxHeight: .infinity)
                ConfirmButton(
                    action: { isShowingScanner = true },
                    title: "familySharing.done.newparent",
                    isContentValid: .constant(true),
                    isLoading: .constant(false),
                    colorBackgroundValid: .appWhite,
                    colorTextValid: .primaryPurple
                )
                CancelButton(action: {
                    openURL(settingsUrl)
                }, title: "familySharing.cancel.newparent", isContentValid: .constant(true))
            }
            .frame(height: contentSize.height)
        }
        .sheet(isPresented: $isShowingScanner) {
            CodeScannerView(codeTypes: [.qr], completion: handleScan)
        }
    }
    
    var steps: some View {
        ZStack(alignment: .leading) {
            Color.primaryCellBackground
                .cornerRadius(cornerRadius)
                .shadow(color: .shadow, radius: 40, x: 0, y: 20)
            VStack(alignment: .leading, spacing: spacing) {
                ForEach(cells, id: \.self) {
                    FamilySharingCell(type: $0)
                }
            }.padding(spacing)
        }
    }
    
    var info: some View {
        ZStack(alignment: .leading) {
            Color.primaryCellBackground
                .cornerRadius(cornerRadius)
                .shadow(color: .shadow, radius: 40, x: 0, y: 20)
            VStack(alignment: .leading, spacing: spacing) {
                ForEach([FamilySharingInfoCellType.setup], id: \.self) {
                    FamilySharingInfoCell(type: $0)
                }
            }.padding(spacing)
        }.frame(height: 73)
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

struct NewParentFamilySharingView_Previews: PreviewProvider {
    static var previews: some View {
        NewParentFamilySharingView(viewModel: MockFamilySharingViewModel())
    }
}
