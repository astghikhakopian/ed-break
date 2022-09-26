//
//  MainBackground.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 26.09.22.
//

import SwiftUI

struct MainBackground: View {
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                navigationBackground(title: "onboarding.role")
                Color.primaryBackground
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Private Components

extension MainBackground {
    
    private func navigationBackground(title: String? = nil) -> some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Image.Background.backgroundEcliipse2
                }
                HStack {
                    Image.Background.backgroundEcliipse1
                    Spacer()
                }
                HStack {
                    Spacer()
                    Image.Background.backgroundEcliipse3
                    Spacer().frame(width: 18)
                }
            }.background(Color.primary)
            if let title = title {
                Text(title)
                    .font(.appLargeTitle)
                    .foregroundColor(Color.appWhite)
            }
        }
    }
}

//struct MainBackground_Previews: PreviewProvider {
//    static var previews: some View {
//        MainBackground()
//    }
//}
