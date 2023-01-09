//
//  ChildQRView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 20.10.22.
//

import SwiftUI

struct ChildQRView<M: ChildQRViewModeling>: View {
    
    @StateObject var viewModel: M
    @EnvironmentObject var appState: AppState
    
    private let cornerRadius = 12.0
    private let spacing = 10.0
    private let loadingSpacing = 16.0
    private let padding = 36.0
    private let gap = 20.0
    
    var body: some View {
        MainBackground(title: "onboarding.childQRCode.title", withNavbar: false) {
            VStack(spacing: gap) {
                content
                Spacer()
                loadingView
            }
        }
    }
}

private extension ChildQRView {
    
    var content: some View {
        ZStack(alignment: .leading) {
            Color.appWhite
                .cornerRadius(cornerRadius)
                .shadow(color: .shadow, radius: 40, x: 0, y: 20)
            VStack(spacing: spacing) {
                Image(uiImage: UIImage(data: getQRCodeData(
                    name: UIDevice.current.name,
                    withSize: CGSize(width: 200, height: 200)
                )!)!)
                .resizable()
                .frame(width: 200, height: 200)
                // Image.QRCode.qrCode.resizable().frame(width: 200, height: 200)
                Text("onboarding.childQRCode.description")
                    .font(.appHeadline)
                    .foregroundColor(.primaryText)
                    .multilineTextAlignment(.center)
            }.padding(padding)
        }
        .onChange(of: viewModel.isLoading) { isloading in
            guard !isloading else { return }
            appState.moveToChildDashboard = true
        }
    }
    
    var loadingView: some View {
        VStack(spacing: loadingSpacing) {
            ProgressView()
                .progressViewStyle(
                    CircularProgressViewStyle(tint: .primaryPurple))
            Text("onboarding.childQRCode.waiting")
                .font(.appHeadline)
                .foregroundColor(.primaryDescription)
                .multilineTextAlignment(.center)
        }
    }
    
    // TODO: - move to viewmodel
    
    func getQRCodeData(name: String, withSize size: CGSize) -> Data? {
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        let deviceToken: String? = "MISSING"
        let json = "{\"uuid\":\"\(UIDevice.current.identifierForVendor!.uuidString)\", \"name\":\"\(name.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? "")\", \"deviceToken\": \"\(deviceToken ?? "MISSING")\"}"
        let data = json.data(using: .ascii, allowLossyConversion: false)
        filter.setValue(data, forKey: "inputMessage")
        guard let ciimage = filter.outputImage else { return nil }
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledCIImage = ciimage.transformed(by: transform)
        let uiimage = UIImage(ciImage: scaledCIImage)
        return uiimage.pngData()!
    }
}

struct ChildQRView_Previews: PreviewProvider {
    static var previews: some View {
        ChildQRView(viewModel: ChildQRViewModel(checkConnectionUseCase: CheckConnectionUseCase(childrenRepository: DefaultChildrenRepository()), localStorageService: UserDefaultsService()))
    }
}