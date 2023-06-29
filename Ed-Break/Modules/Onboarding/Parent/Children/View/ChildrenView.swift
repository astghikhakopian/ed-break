//
//  ChildrenView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 03.10.22.
//

import SwiftUI
import CodeScanner
import FamilyControls

struct ChildrenView<M: ChildrenViewModeling>: View {
    
    @StateObject var viewModel: M
    @EnvironmentObject var appState: AppState
    
    @State private var isShowingScanner: Bool = false
    @State private var isDiscouragedPresented: Bool = false
    
    @State var selectionToDiscourage: FamilyActivitySelection = FamilyActivitySelection()
    @State var uuid: String = ""

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
                    guard !viewModel.connectedChildren.isEmpty /*.count == viewModel.children.count*/ else { return }
                    appState.moveToDashboard = true
                    UserDefaultsService().setPrimitive(true, forKey: .User.isLoggedIn)
                }, title: "common.continue", isContentValid: $viewModel.isContentValid, isLoading:  $viewModel.isLoading,colorBackgroundValid: .appWhite,colorBackgroundInvalid: .appWhite,colorTextValid: .primaryPurple,colorTextInvalid: .border)
            }
        }.onAppear {
            viewModel.getChildren(filtered: false)
        }
        .sheet(isPresented: $isShowingScanner) {
            CodeScannerView(codeTypes: [.qr], completion: handleScan)
        }
        .familyActivityPicker(isPresented: $isDiscouragedPresented, selection: $selectionToDiscourage)
        .hiddenTabBar()
        .onChange(of: isDiscouragedPresented) { newValue in
            if newValue == false {
                
                guard let scanningChild = scanningChild else { return }
                pairChild(scanningChild: scanningChild, deviceToken: uuid) {
                    viewModel.addRestrictions(childId: $0, selection: selectionToDiscourage)
                }
                    
            }
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
            self.uuid = uuid
            guard let _ = scanningChild else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isDiscouragedPresented = true
            }
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    func pairChild(scanningChild: ChildModel, deviceToken: String, complition: @escaping (Int)->()) {
        viewModel.pairChild(id: scanningChild.id, deviceToken: deviceToken) { success in
            guard success else { return }
            DispatchQueue.main.async {
                viewModel.connectedChildren.append(scanningChild)
                complition(scanningChild.id)
            }
        }
        self.scanningChild = nil
    }
}

private extension ChildrenView {
    
    var content: some View {
        ZStack(alignment: .leading) {
            Color.primaryCellBackground
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
