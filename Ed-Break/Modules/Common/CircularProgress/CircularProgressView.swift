//
//  CircularProgressView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 01.11.22.
//

import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    
    private let width: CGFloat = 13
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.divader,
                    lineWidth: width
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.primaryPurple,
                    style: StrokeStyle(
                        lineWidth: width,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)

        }
    }
}
