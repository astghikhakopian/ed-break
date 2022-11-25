//
//  ChildEditView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 25.10.22.
//

import SwiftUI

struct ChildEditView<M: ChildDetailsViewModeling>: View {
    
    @ObservedObject var viewModel: M
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var showDeletingAlert: Bool = false
    private let cornerRadius = 12.0
    private let spacing = 25.0
    private let gap = 20.0
    
    var body: some View {
        MainBackground(title: "onboarding.childDetails.title", withNavbar: true) {
            VStack(spacing: gap) {
                childView
                ConfirmButton(action: {
                    viewModel.updateChild {
                        presentationMode.wrappedValue.dismiss()
                    }
                }, title: "common.continue", isContentValid: $viewModel.isContentValid, isLoading: $viewModel.isLoading)
                CancelButton(action: {
                    showDeletingAlert = true
                }, title: "childDetails.delete", color: .primaryRed, isContentValid: .constant(true))
            }
        }.alert("main.parent.settings.delete.description", isPresented: $showDeletingAlert, actions: {
            Button("common.delete", role: .destructive, action: {
                guard !viewModel.isLoading else { return }
                viewModel.deleteChild {
                    DispatchQueue.main.async {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            })
        }, message: {
            Text("main.parent.settings.delete.description.details")
        })
    }
}

private extension ChildEditView {
    
    var childView: some View {
        ZStack(alignment: .leading) {
            Color.appWhite
                .cornerRadius(cornerRadius)
                .shadow(color: .shadow, radius: 40, x: 0, y: 20)
            VStack(alignment: .leading, spacing: spacing) {
                ForEach($viewModel.children, id: \.id) { child in
                    uploadPhotoView(image: child.image)
                    CommonTextField(title: "childDetails.name", text: child.childName)
//                    PickerTextField(title: "childDetails.grade", selection: child.grade, datasource: $viewModel.grades)
                    if $viewModel.children.count > 1 {
                        CancelButton(action: {
                            guard !viewModel.isLoading else { return }
                            viewModel.removeChild(child:  child.wrappedValue)
                        }, title: "childDetails.delete", color: .primaryRed, isContentValid: .constant(true))
                    }
                }
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

struct ChildEditView_Previews: PreviewProvider {
    
    @State static var childName = "Emma"
    @State static var gradeLevel = "Grade 2"
    
    static var previews: some View {
        ChildDetailsView(viewModel: MockChildDetailsViewModel())
    }
}
