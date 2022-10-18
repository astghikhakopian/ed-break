//
//  ChildDetails.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.10.22.
//

import SwiftUI

struct ChildDetailsView<M: ChildDetailsViewModeling>: View {
    
    @ObservedObject var viewModel: M
    
    private let cornerRadius = 12.0
    private let spacing = 25.0
    private let gap = 20.0
    
    var body: some View {
        MainBackground(title: "onboarding.childDetails.title", withNavbar: true) {
            VStack(spacing: gap) {
                childView
                NavigationButton(
                    title: "common.continue",
                    didTap: {
                        viewModel.appendChildren()
                    },
                    isContentValid: $viewModel.isContentValid,
                    isLoading: $viewModel.isLoading,
                    shouldNavigateAfterLoading: true,
                    content: { QRCodeView() })
            }
        }
    }
}

private extension ChildDetailsView {
    
    var childView: some View {
        ZStack(alignment: .leading) {
            Color.appWhite
                .cornerRadius(cornerRadius)
                .shadow(color: .shadow, radius: 40, x: 0, y: 20)
            VStack(alignment: .leading, spacing: spacing) {
                ForEach($viewModel.children, id: \.id) { child in
                    uploadPhotoView(image: child.image)
                    CommonTextField(title: "childDetails.name", text: child.childName)
                    PickerTextField(title: "childDetails.grade", selection: child.grade, datasource: $viewModel.grades)
                    if $viewModel.children.count > 1 {
                        CancelButton(action: {
                            guard !viewModel.isLoading else { return }
                            viewModel.addAnotherChild()
                        }, title: "childDetails.delete", color: .primaryRed)
                    }
                }
                CancelButton(action: {
                    guard !viewModel.isLoading else { return }
                    viewModel.addAnotherChild()
                }, title: "childDetails.add")
            }.padding(spacing)
        }
    }
    
    func uploadPhotoView(image: Binding<UIImage>) -> some View {
        HStack {
            Spacer()
            ImageUploadView(selectedImage: image)
            Spacer()
        }
    }
}

struct ChildDetails_Previews: PreviewProvider {
    
    @State static var childName = "Emma"
    @State static var gradeLevel = "Grade 2"
    
    static var previews: some View {
        ChildDetailsView(viewModel: MockChildDetailsViewModel())
    }
}
