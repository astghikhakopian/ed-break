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
    @State private var showCamera = false
    @State private var showingOptions = false
    
    private let uploadPlaceholderHeight = 88.0
    
    var body: some View {
        Button {
            showingOptions = true
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
        .confirmationDialog("childDetails.upload.options", isPresented: $showingOptions, titleVisibility: .visible) {
            Button("childDetails.upload.takePhoto") {
                showCamera = true
            }
            
            Button("childDetails.upload.choose") {
                showSheet = true
            }
            if selectedImage != UIImage() {
                Button("childDetails.upload.clear", role: .destructive) {
                    selectedImage = UIImage()
                }
            }
        }
        .sheet(isPresented: $showSheet) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $selectedImage)
        }
        .sheet(isPresented: $showCamera) {
            ImagePicker(sourceType: .camera, selectedImage: $selectedImage)
        }   
    }
}

struct ImageUploadView_Previews: PreviewProvider {
    
    @State static var image = UIImage(named: "childDetails.upload.placeholder")!
    
    static var previews: some View {
        ImageUploadView(selectedImage: $image)
    }
}
