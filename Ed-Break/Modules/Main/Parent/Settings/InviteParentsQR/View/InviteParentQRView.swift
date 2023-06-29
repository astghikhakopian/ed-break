//
//  InviteParentQRView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 27.06.23.
//

import SwiftUI

struct InviteParentQRView: View {
    
    private let cornerRadius = 12.0
    private let spacing = 10.0
    private let loadingSpacing = 16.0
    private let padding = 36.0
    private let gap = 20.0
    
    var body: some View {
        MainBackground(title: "onboarding.parentQRCode.title", withNavbar: true) {
            content
        }
    }
}

private extension InviteParentQRView {
    
    var content: some View {
        ZStack {
            Color.primaryCellBackground
                .cornerRadius(cornerRadius)
                .shadow(color: .shadow, radius: 40, x: 0, y: 20)
            VStack(spacing: spacing) {
                Image(uiImage: UIImage(data: getQRCodeData(
                    name: UIDevice.current.name,
                    withSize: CGSize(width: 200, height: 200)
                )!)!)
                .resizable()
                .frame(width: 200, height: 200)
                Text("onboarding.parentQRCode.description")
                    .font(.appHeadline)
                    .foregroundColor(.primaryText)
                    .multilineTextAlignment(.center)
            }.padding(padding)
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


struct InviteParentQRView_Previews: PreviewProvider {
    static var previews: some View {
        InviteParentQRView()
    }
}
