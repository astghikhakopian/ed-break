//
//  CoachingView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 31.10.22.
//

import SwiftUI

struct CoachingView<M: CoachingViewModeling>: View {
    
    @StateObject var viewModel: M
    
    private let cornerRadius = 12.0
    private let spacing = 14.0
    private let padding = 20.0
    private let gap = 20.0
    
    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(
                        CircularProgressViewStyle(tint: .appWhite))
            } else {
                VStack(spacing: gap) {
                    timeHeader
                    content
                }
            }
        }.onLoad {
            viewModel.getCoachingChildren()
        }
    }
}

private extension CoachingView {
    var content: some View {
        ForEach($viewModel.children.results, id: \.id) { $child in
            CoachingCell(child: $child)
        }
    }
    
    var timeHeader: some View {
        WheelPickerField(style: .withImage(image: .ChildDetails.calender, title: "main.parent.childProfile.timePeriod"), selection: $viewModel.selectedPeriod, datasource: $viewModel.timePeriodDatasource).background(Color.primaryBackground)
//            Menu {
//                Picker(selection: $viewModel.selectedPeriod) {
//                    ForEach(viewModel.timePeriodDatasource, id: \.self) {
//                        Text($0.name)
//                            .font(.appHeadline)
//                    }.font(.appHeadline)
//                } label: { }
//            } label: {
//                HStack {
//                    Image.ChildDetails.calender
//                    Text(viewModel.selectedPeriod.name)
//                        .font(.appHeadline)
//                        .foregroundColor(.black)
//                    Spacer()
//                    Image.Common.dropdownArrow
//                }.padding(EdgeInsets(top: 16, leading: padding, bottom: 16, trailing: padding))
//                .background(Color.appWhite)
//                .cornerRadius(cornerRadius)
//            }.foregroundColor(.primaryPurple)
        
    }
}

struct CoachingView_Previews: PreviewProvider {
    static var previews: some View {
        CoachingView(viewModel: MockCoachingViewModel())
    }
}
