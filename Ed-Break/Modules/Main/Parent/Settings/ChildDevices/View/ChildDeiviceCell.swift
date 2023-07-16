//
//  ChildDeiviceCell.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 25.10.22.
//

import SwiftUI
import Foundation
import Kingfisher

struct ChildDeiviceCell: View {
    
    let name: String
    let grade: Grade
    let imageUrl: URL?
    
    private let imageHeight = 42.0
    private let padding = EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20)
    private let cornerRadius = 12.0
    private let borderWidth = 1.0
    private let spacing = 10.0
    private let labelHeight = 30.0
    
    var body: some View {
        HStack(spacing: spacing) {
            if let imageUrl = imageUrl {
                KFImage.url(imageUrl)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imageHeight, height: imageHeight)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(imageHeight/2)
            } else {
                Image.ChildDetails.uploadPlaceholder
                    .resizable()
                    .frame(width: imageHeight, height: imageHeight)
                    .cornerRadius(imageHeight/2)
            }
            VStack(alignment: .leading) {
                Text(name)
                    .font(.appButton)
                Text(grade.name)
                    .font(.appBody)
                    .foregroundColor(.primaryDescription)
            }
            Spacer()
            Image.Settings.more
        }
        .padding(padding)
        .background(Color.primaryCellBackground)
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color.border, lineWidth: borderWidth)
        )
    }
}

/*
struct ChildDeiviceCell_Previews: PreviewProvider {
    @State static var state: ChildCellState = .connected
    static var previews: some View {
        ChildCell(name: "Emma", grade: [Grade.third], imageUrl: nil, state: $state) { }
    }
}
*/
