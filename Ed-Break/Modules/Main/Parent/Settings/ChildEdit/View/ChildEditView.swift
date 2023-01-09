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
    
    @State private var uiTabarController: UITabBarController?
    
    @State private var showDeletingAlert: Bool = false
    @State private var showGradeOptions = false
    @State private var showSubjects = false
    
    private let cornerRadius = 12.0
    private let spacing = 25.0
    private let gap = 20.0
    private let labelHeight = 30.0
    private let borderWidth = 1.0
    private let padding = EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20)
    
    var body: some View {
        MainBackground(title: "onboarding.childDetails.title", withNavbar: true) {
            VStack(spacing: gap) {
                childView
                ConfirmButton(action: {
                    viewModel.updateChild {
                        DispatchQueue.main.async {
                            presentationMode.wrappedValue.dismiss()
                        }
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
        .bottomsheet(title: "childDetails.subjects", datasource: viewModel.subjects, selectedItems: $viewModel.children[0].subjects, isPresented: $showSubjects, isMultiselect: true)
        .confirmationDialog("childDetails.grade", isPresented: $showGradeOptions, titleVisibility: .visible) {
            ForEach(viewModel.grades, id: \.rawValue) { grade in
                Button(grade.name) {
                    viewModel.children[0].grade = grade
                }
            }
        }
        .introspectTabBarController { (UITabBarController) in
            UITabBarController.tabBar.isHidden = true
            uiTabarController = UITabBarController
        }.onDisappear{
            uiTabarController?.tabBar.isHidden = false
        }
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
                    HStack(spacing: 10) {
                        WheelPickerField(style: .titled(title: "childDetails.grade"), selection: child.grade, datasource: $viewModel.grades)
                        WheelPickerField(style: .titled(title: "childDetails.interruption"), selection: $viewModel.children[0].interuption, datasource: $viewModel.interuptions)
                    }
                    dropdown(title: "childDetails.subjects", selectedItems: child.subjects) {
                        UIApplication.shared.endEditing()
                        showSubjects = true
                    }
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
            ImageUploadView(selectedImage: image, placeholderImageStringUrl: viewModel.children[0].photoStringUrl)
            Spacer()
        }
    }
    func dropdown(title: String, placeholder: String = "common.select", selectedItems: Binding<[BottomsheetCellModel]?>, action: @escaping ()->()) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(LocalizedStringKey(title))
                .font(.appHeadline)
                .frame(height: labelHeight)
                .foregroundColor(.primaryDescription)
            Button(action: action, label: {
                HStack {
                    if let title = selectedItems.wrappedValue?.map { $0.title }.joined(separator: ", ") {
                        Text(title)
                            .font(.appHeadline)
                            .background(Color.appWhite)
                            .accentColor(.primaryPurple)
                            .cornerRadius(cornerRadius)
                            .lineLimit(1)
                    } else {
                        Text(LocalizedStringKey(placeholder))
                            .font(.appHeadline)
                            .background(Color.appWhite)
                            .accentColor(.primaryPurple)
                            .cornerRadius(cornerRadius)
                    }
                    Spacer()
                    Image.Common.dropdownArrow
                }.padding(padding)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(Color.border, lineWidth: borderWidth)
                    )
            })
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