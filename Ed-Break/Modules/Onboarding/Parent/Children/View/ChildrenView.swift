//
//  ChildrenView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 03.10.22.
//

import SwiftUI
import CodeScanner

struct ChildrenView<M: ChildrenViewModeling>: View {
    
    @StateObject var viewModel: M
    @EnvironmentObject var appState: AppState
    
    @State private var isShowingScanner = false
    
    @State private var scanningChild: ChildModel?
    
    private let cornerRadius = 12.0
    private let spacing = 14.0
    private let padding = 20.0
    private let gap = 20.0
    
    var body: some View {
        MainBackground(title: "onboarding.children.title", withNavbar: true) {
            VStack(spacing: gap) {
                content
                ConfirmButton(action: {
                    guard viewModel.connectedChildren.count == viewModel.children.count else { return }
                    appState.moveToDashboard = true
                }, title: "common.continue", isContentValid: $viewModel.isContentValid, isLoading:  $viewModel.isLoading)
            }
        }.onAppear {
            viewModel.getChildren()
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
            guard let scanningChild = scanningChild else { return }
            viewModel.pairChild(id: scanningChild.id, deviceToken: uuid) { success in
                guard success else { return }
                viewModel.connectedChildren.append(scanningChild)
            }
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
        scanningChild = nil
    }
}

private extension ChildrenView {
    
    var content: some View {
        ZStack(alignment: .leading) {
            Color.appWhite
                .cornerRadius(cornerRadius)
                .shadow(color: .shadow, radius: 40, x: 0, y: 20)
            VStack(alignment: .leading, spacing: spacing) {
                Text("children.description")
                    .font(.appHeadline)
                    .foregroundColor(.primaryText)
                    .multilineTextAlignment(.center)
                ForEach(viewModel.children.results, id: \.id) { child in
                    ChildCell(name: child.name, grade: child.grade, imageUrl: child.photoUrl, state: Binding.constant(viewModel.connectedChildren.contains(child) ? .connected : .scan), scanAction: {
                        scanningChild = child
                        isShowingScanner = true
                    })
                }
            }.padding(spacing)
        }
    }
}


struct ChildrenView_Previews: PreviewProvider {
    static var previews: some View {
        ChildrenView(viewModel: MockChildrenViewModeling())
    }
}
