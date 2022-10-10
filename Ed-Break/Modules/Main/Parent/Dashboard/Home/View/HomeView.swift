//
//  HomeView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 10.10.22.
//

import SwiftUI

struct HomeView<M: ChildrenViewModeling>: View {
    
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
                    content
                }
            }
        }
        .onAppear { viewModel.getChildren() }
    }
}

private extension HomeView {
    
    var content: some View {
        
        ForEach(viewModel.children.results, id: \.id) { child in
            NavigationLink(
                destination: Text("\(child.name) Details"),
                label: { HomeChildCell(child: child) })
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: MockChildrenViewModeling())
    }
}
