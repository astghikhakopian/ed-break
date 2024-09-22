//
//  ChildEditView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 25.10.22.
//

import SwiftUI
import CodeScanner

struct ChildEditView<M: ChildDetailsViewModeling>: View {
    
    @ObservedObject var viewModel: M
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var isShowingScanner: Bool = false
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
        MainBackground(title: "onboarding.childsDetails.title", withNavbar: true) {
            
            if viewModel.children.isEmpty {
                EmptyView()
            } else {
                VStack(spacing: gap) {
                    childView//(child: $viewModel.children[0])
                    childDevicesView(child: viewModel.children[0])
                    confirmButton
                    deleteButton
                }
            }
        }
        .alert(
            "main.parent.settings.delete.description",
            isPresented: $showDeletingAlert,
            actions: { alertDeleteButton },
            message: { Text("main.parent.settings.delete.description.details") }
        )
        .bottomsheet(
            title: "childDetails.subjects",
            datasource: viewModel.subjects,
            selectedItems: $viewModel.children[0].subjects,
            isPresented: $showSubjects,
            isMultiselect: true
        )
        .confirmationDialog(
            "childDetails.grade",
            isPresented: $showGradeOptions,
            titleVisibility: .visible
        ) {
            ForEach(viewModel.grades, id: \.rawValue) { grade in
                Button(grade.name) {
                    guard !viewModel.children.isEmpty else { return }
                    viewModel.children[0].grade = grade
                }
            }
        }
        .sheet(isPresented: $isShowingScanner) {
            CodeScannerView(codeTypes: [.qr], completion: handleScan)
        }
        .hiddenTabBar()
    }
}

private extension ChildEditView {
  var childView: some View {
        ZStack(alignment: .leading) {
            Color.primaryCellBackground
                .cornerRadius(cornerRadius)
                .shadow(color: .shadow, radius: 40, x: 0, y: 20)
            VStack(alignment: .leading, spacing: spacing) {
                ForEach($viewModel.children, id: \.id) { child in
                    uploadPhotoView(image: child.image)
                    CommonTextField(title: "childDetails.name", placeHolder: "childDetails.name.placeholder", text: child.childName)
                    WheelPickerField(style: .titled(title: "childDetails.grade"), selection: child.grade, datasource: $viewModel.grades) {
                        UIApplication.shared.endEditing()
                    }
                    HStack(spacing: 10) {
                        WheelPickerField(
                            style: .titled(
                                title: "childDetails.interruption",
                                titleToShow: "childDetails.interruption.period"
                            ),
                            selection: $viewModel.children[0].intervalBetweenIncorrect,
                            datasource: $viewModel.intervalBetweenIncorrect
                        ) {
                            UIApplication.shared.endEditing()
                        }
                        WheelPickerField(
                            style: .titled(
                                title: "childDetails.interruption.frequency",
                                titleToShow: "childDetails.interruption.frequency"
                            ),
                            selection: $viewModel.children[0].interuption,
                            datasource: $viewModel.interuptions
                        ) {
                            UIApplication.shared.endEditing()
                        }
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
    
    func childDevicesView(child: ChildDetailsModel) -> some View {
        ZStack(alignment: .leading) {
            Color.primaryCellBackground
                .cornerRadius(cornerRadius)
                .shadow(color: .shadow, radius: 40, x: 0, y: 20)
            VStack(alignment: .leading, spacing: spacing) {
                ForEach(child.devices, id: \.id) { device in
                    NavigationLink {
                        NavigationLazyView(
                            DeviceDetailsView(
                                device: device,
                                deleteAction: {
                                    viewModel.removeDevice(device: $0) { success in
                                        guard success else { return }
                                        DispatchQueue.main.async {
                                            presentationMode.wrappedValue.dismiss()
                                        }
                                    }
                                }
                            )
                        )
                    } label: {
                        ChildDeviceCell(device: device)
                    }
                }
                addChildDeviceButton
            }.padding(spacing)
        }
    }
    
    var confirmButton: some View {
        ConfirmButton(
            action: {
                viewModel.updateChild {
                    DispatchQueue.main.async {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            },
            title: "childDetails.save",
            isContentValid: $viewModel.isContentValid,
            isLoading: $viewModel.isLoading,
            colorBackgroundValid: .appWhite,
            colorBackgroundInvalid: .border,
            colorTextValid: .primaryPurple,
            colorTextInvalid: .primaryDescription
        )
    }
    
    var deleteButton: some View {
        ZStack {
            Color.appWhite
            CancelButton(
                action: { showDeletingAlert = true },
                title: "childDetails.delete",
                color: .primaryRed,
                isContentValid: .constant(true)
            )
        }
        .cornerRadius(cornerRadius)
    }
    
    var addChildDeviceButton: some View {
        ZStack {
            Color.border
            CancelButton(
                action: { isShowingScanner = true },
                title: (viewModel.children.first?.devices.isEmpty ?? true) ?
                  "childDetails.add.device" :
                  "childDetails.add.device.another",
                color: .primaryPurple,
                isContentValid: .constant(true)
            )
        }
        .cornerRadius(cornerRadius)
    }
    
    var alertDeleteButton: some View {
        Button(
            "common.delete",
            role: .destructive,
            action: {
                guard !viewModel.isLoading else { return }
                viewModel.deleteChild {
                    DispatchQueue.main.async {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        )
    }
    
    func uploadPhotoView(image: Binding<UIImage>) -> some View {
        HStack {
            Spacer()
            ImageUploadView(selectedImage: image, placeholderImageStringUrl: viewModel.children[0].photoStringUrl)
            Spacer()
        }
    }
    func dropdown(
        title: String,
        placeholder: String = "common.select",
        selectedItems: Binding<[BottomsheetCellModel]?>,
        action: @escaping ()->()
    ) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(LocalizedStringKey(title))
                .font(.appHeadline)
                .frame(height: labelHeight)
                .foregroundColor(.primaryDescription)
            Button(
                action: action,
                label: {
                    HStack {
                        if let title = selectedItems.wrappedValue?.map({ $0.title }).joined(separator: ", ") {
                            Text(title)
                                .font(.appHeadline)
                                .background(Color.primaryCellBackground)
                                .accentColor(.appBlack)
                                .cornerRadius(cornerRadius)
                                .lineLimit(1)
                        } else {
                            Text(LocalizedStringKey(placeholder))
                                .font(.appHeadline)
                                .background(Color.primaryCellBackground)
                                .accentColor(.appBlack)
                                .cornerRadius(cornerRadius)
                        }
                        Spacer()
                        Image.Common.dropdownArrow
                    }
                    .padding(padding)
                        .overlay(
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .stroke(Color.border, lineWidth: borderWidth)
                        )
                }
            )
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
       isShowingScanner = false
        
        switch result {
        case .success(let info):
            let string = info.string
            guard
                let child = viewModel.children.first,
                let childId = child.childId,
                let data = string.data(using: .utf8),
                let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any],
                let uuid = json["uuid"] as? String,
                let name = json["name"] as? String,
                let model = json["model"] as? String
            else { return }
            viewModel.pairChild(id: childId, deviceToken: uuid, name: name.removingPercentEncoding ?? "", model: model) { success in
                guard success else { return }
                DispatchQueue.main.async {
                    presentationMode.wrappedValue.dismiss()
                }
                
            }
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
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
