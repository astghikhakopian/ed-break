//
//  HomeView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.11.22.
//

import SwiftUI

struct HomeView: View {
    
    let progressWidth: CGFloat = 180
    let textSpacing: CGFloat = 4
    let headerPadding: CGFloat = 35
    private let cornerRadius = 12.0
    
    var body: some View {
        HStack {
            Spacer()
            
            ZStack {
                VStack(spacing: textSpacing) {
                    HStack(alignment: .bottom, spacing: textSpacing) {
                        Text("36")
                            .font(.appHeadingH2)
                            .foregroundColor(.primaryPurple)
                        Text("main.child.home.min")
                            .font(.appHeadline)
                            .foregroundColor(.primaryPurple).frame(height: 30)
                    }
                    Text("main.child.home.usage")
                        .font(.appBody)
                        .foregroundColor(.primaryDescription)
                        .multilineTextAlignment(.center)
                }
                
                CircularProgressView(progress: 0.7).frame(width: progressWidth)
            }.padding(headerPadding)
            Spacer()
        }.background(Color.appWhite)
            .cornerRadius(cornerRadius)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
