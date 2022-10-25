//
//  ChildDevicesView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 24.10.22.
//

import SwiftUI
import CodeScanner

struct ChildDevicesView<M: ChildrenViewModeling>: View {
    
    @StateObject var viewModel: M
    
    private let cornerRadius = 12.0
    private let spacing = 14.0
    private let padding = 20.0
    private let gap = 20.0
    
    var body: some View {
        MainBackground(title: "main.parent.settings.childDevices", withNavbar: true) {
            ZStack(alignment: .leading) {
                Color.appWhite
                    .cornerRadius(cornerRadius)
                    .shadow(color: .shadow, radius: 40, x: 0, y: 20)
                VStack(spacing: gap) {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(
                                CircularProgressViewStyle(tint: .primaryPurple))
                    } else {
                        content
                    }
                    NavigationLink {
                        ChildDetailsView(simpleAdd: true, viewModel: ChildDetailsViewModel(addChildUseCase: AddChildUseCase(childDetailsRepository: DefaultChildDetailsRepository())))
                    } label: {
                        CancelButton(action: { }, title: "childDetails.add").disabled(true)
                    }
                }.padding(spacing)
            }
        }.onAppear {
            viewModel.getChildren()
        }
    }
}

private extension ChildDevicesView {
    
    var content: some View {
        
        VStack(alignment: .leading, spacing: spacing) {
            ForEach(viewModel.children.results, id: \.id) { child in
                ChildDeiviceCell(name: child.name, grade: child.grade, imageUrl: child.photoUrl)
            }
        }
        
    }
}


struct ChildDevicesView_Previews: PreviewProvider {
    static var previews: some View {
        ChildDevicesView(viewModel: MockChildrenViewModeling())
    }
}
