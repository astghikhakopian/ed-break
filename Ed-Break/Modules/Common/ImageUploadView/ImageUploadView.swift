//
//  ImageUploadView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 02.10.22.
//

import SwiftUI

struct ImageUploadView: View {
    
    @Binding var selectedImage: UIImage
    
    @State private var showSheet = false
    
    private let uploadPlaceholderHeight = 88.0
    
    var body: some View {
        Button {
            showSheet = true
        } label: {
            VStack(alignment: .center) {
                if selectedImage != UIImage() {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .cornerRadius(uploadPlaceholderHeight/2)
                        .frame(width: uploadPlaceholderHeight, height: uploadPlaceholderHeight)
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                } else {
                    Image.ChildDetails.uploadPlaceholder
                }
                
                Text("childDetails.upload")
                    .foregroundColor(.primaryPurple)
                    .font(.appHeadline)
            }
        }
        .sheet(isPresented: $showSheet) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $selectedImage)
        }
    }
}

struct ImageUploadView_Previews: PreviewProvider {
    
    @State static var image = UIImage(named: "childDetails.upload.placeholder")!
    
    static var previews: some View {
        ImageUploadView(selectedImage: $image)
    }
}
