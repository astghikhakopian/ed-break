//
//  ChildDetails.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.10.22.
//

import SwiftUI

struct ChildDetailsView<M: ChildDetailsViewModeling>: View {
    
    var simpleAdd: Bool = false
    @ObservedObject var viewModel: M

    @State private var selectedChildIndex: Int?
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
        .bottomsheet(title: "childDetails.subjects", datasource: viewModel.subjects, selectedItems: selectedChildIndex == nil ? .constant([]) : $viewModel.children[selectedChildIndex!].subjects, isPresented: $showSubjects, isMultiselect: true)
        .confirmationDialog("childDetails.grade", isPresented: $showGradeOptions, titleVisibility: .visible) {
            ForEach(viewModel.grades, id: \.rawValue) { grade in
                Button(grade.name) {
                    guard let selectedChildIndex = selectedChildIndex, viewModel.children.count > selectedChildIndex else { return }
                    viewModel.children[selectedChildIndex].grade = grade
                }
            }
        }
        .hiddenTabBar()
    }
}

private extension ChildDetailsView {
    
    var childView: some View {
        ZStack(alignment: .leading) {
            Color.primaryCellBackground
                .cornerRadius(cornerRadius)
                .shadow(color: .shadow, radius: 40, x: 0, y: 20)
            VStack(alignment: .leading, spacing: spacing) {
                ForEach($viewModel.children, id: \.id) { child in
                    if child.isHidden.wrappedValue {
                        EmptyView()
                    } else {
                        uploadPhotoView(image: child.image)
                        CommonTextField(title: "childDetails.name", placeHolder: "childDetails.name.placeholder", text: child.childName)
                        WheelPickerField(
                            style: .titled(
                                title: "childDetails.grade"
                            ),
                            selection: child.grade,
                            datasource: $viewModel.grades
                        )
                        .tint(.primaryPurple)
                    HStack(spacing: 10) {
                        WheelPickerField(
                            style: .titled(
                                title: "childDetails.interruption",
                                titleToShow: "childDetails.interruption.period"
                            ),
                            selection: child.intervalBetweenIncorrect,
                            datasource: $viewModel.intervalBetweenIncorrect
                        )
                        WheelPickerField(
                            style: .titled(
                                title: "childDetails.interruption.frequency",
                                titleToShow: "childDetails.interruption.frequency"
                            ),
                            selection: child.interuption,
                            datasource: $viewModel.interuptions
                        )
                    }
                    dropdown(title: "childDetails.subjects", selectedItems: child.subjects) {
                        selectedChildIndex = viewModel.children.firstIndex(where: {$0.id == child.wrappedValue.id})
                        UIApplication.shared.endEditing()
                        showSubjects = true
                    }
                        if $viewModel.children.filter({ !$0.isHidden.wrappedValue }).count > 1 {
                            ZStack {
                                Color.primaryRed.opacity(0.05)
                                CancelButton(action: {
                                    guard !viewModel.isLoading else { return }
                                    viewModel.removeChild(child:  child.wrappedValue)
                                }, title: "childDetails.delete", color: .primaryRed, isContentValid: .constant(true))
                            }.cornerRadius(cornerRadius)
                        }
                    }
                }
                if !simpleAdd {
                    ZStack {
                        Color.border
                        CancelButton(action: {
                            guard !viewModel.isLoading else { return }
                            viewModel.addAnotherChild()
                        }, title: "childDetails.add", color: viewModel.isContentValid ? Color.primaryPurple : Color.appWhite,isContentValid: $viewModel.isContentValid)
                    }.cornerRadius(cornerRadius)
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
    
    func dropdown(title: String, placeholder: String = "common.select", selectedItems: Binding<[BottomsheetCellModel]?>, action: @escaping ()->()) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(LocalizedStringKey(title))
                .font(.appHeadline)
                .frame(height: labelHeight)
                .foregroundColor(.primaryDescription)
            Button(action: action, label: {
                HStack {
                    if let title = selectedItems.wrappedValue?.map({ $0.title }).joined(separator: ", ") {
                        Text(title)
                            .font(.appHeadline)
                            .background(Color.primaryCellBackground)
                            .accentColor(.black)
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
                }.padding(padding)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(Color.border, lineWidth: borderWidth)
                    )
            })
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
