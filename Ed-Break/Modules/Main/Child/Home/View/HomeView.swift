//
//  HomeView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.11.22.
//

import SwiftUI

struct HomeView<M: HomeViewModeling>: View {
    
    @StateObject var viewModel: M
    
    private let progressWidth: CGFloat = 180
    private let textSpacing: CGFloat = 4
    private let headerPadding: CGFloat = 35
    private let headerHeight: CGFloat = 30
    private let cornerRadius = 12.0
    
    
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Spacer()
                
                ZStack {
                    VStack(spacing: textSpacing) {
                        HStack(alignment: .bottom, spacing: textSpacing) {
                            Text(String(viewModel.contentModel?.restrictionTime ?? 0))
                                .font(.appHeadingH2)
                                .foregroundColor(.primaryPurple)
                            Text("main.child.home.min")
                                .font(.appHeadline)
                                .foregroundColor(.primaryPurple)
                                .frame(height: headerHeight)
                        }
                        Text("main.child.home.usage")
                            .font(.appBody)
                            .foregroundColor(.primaryDescription)
                            .multilineTextAlignment(.center)
                    }
                    
                    CircularProgressView(progress: 0.7)
                        .frame(height: progressWidth)
                }.padding(headerPadding)
                Spacer()
            }.background(Color.appWhite)
                .cornerRadius(cornerRadius)
            ForEach(viewModel.contentModel?.subjects ?? [], id: \.id) { subject in
                LessonCell(model: subject)
            }
        }.onAppear {
            viewModel.getSubjects()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: MockHomeViewModel())
    }
}
