//
//  ChildDetails.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.10.22.
//

import SwiftUI

struct ChildDetails<M: ChildDetailsViewModeling>: View {
    
    @ObservedObject var viewModel: M
    
    private let cornerRadius = 12.0
    private let spacing = 25.0
    private let gap = 15.0
    
    var body: some View {
        MainBackground(title: "onboarding.childDetails.title", withNavbar: true) {
            VStack(spacing: gap) {
                childView
                NavigationButton(
                    title: "common.continue",
                    didTap: {  },
                    content: { Text("uhj") })
            }
        }
        
    }
}

private extension ChildDetails {
    
    var childView: some View {
        ZStack(alignment: .leading) {
            Color.appWhite
                .cornerRadius(cornerRadius)
                .shadow(color: .shadow, radius: 40, x: 0, y: 20)
            VStack(alignment: .leading, spacing: spacing) {
                uploadPhotoView
                CommonTextField(title: "childDetails.name", text: $viewModel.childName)
                PickerTextField(title: "childDetails.grade", selection: $viewModel.grade, datasource: $viewModel.grades)
                CancelButton(action: {
                    print("grade")
                }, title: "childDetails.add")
            }.padding(spacing)
        }
    }
    
    var uploadPhotoView: some View {
        HStack {
            Spacer()
            ImageUploadView(selectedImage: $viewModel.image)
            Spacer()
        }
    }
}

struct ChildDetails_Previews: PreviewProvider {
    
    @State static var childName = "Emma"
    @State static var gradeLevel = "Grade 2"
    
    static var previews: some View {
        ChildDetails(viewModel: MockChildDetailsViewModel())
    }
}
