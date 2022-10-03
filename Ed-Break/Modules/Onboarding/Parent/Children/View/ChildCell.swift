//
//  ChildCell.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 03.10.22.
//

import SwiftUI

enum ChildCellState {
    case connected, scan
}

struct ChildCell: View {
    
    let name: String
    let grade: Grade
    @Binding var state: ChildCellState
    let scanAction: () -> Void
    
    private let imageHeight = 42.0
    private let padding = EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20)
    private let cornerRadius = 12.0
    private let borderWidth = 1.0
    private let spacing = 10.0
    private let labelHeight = 30.0
    
    var body: some View {
        HStack(spacing: spacing) {
            Image.ChildDetails.uploadPlaceholder
                .resizable()
                .frame(width: imageHeight, height: imageHeight)
                .cornerRadius(imageHeight/2)
            VStack(alignment: .leading) {
                Text(name)
                    .font(.appButton)
                Text(grade.name)
                    .font(.appBody)
                    .foregroundColor(.primaryDescription)
            }
            Spacer()
            switch state {
            case .connected:
                HStack {
                    Image.Common.checkmark
                    Text("childern.connected")
                        .font(.appHeadline)
                        .foregroundColor(.primaryGreen)
                }
            case .scan:
                Button(action: scanAction, label: {
                    Text("childern.scanQR")
                        .font(.appHeadline)
                        .foregroundColor(.primaryPurple)
                })
            }
        }
        .padding(padding)
        .background(Color.appWhite)
        .cornerRadius(cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color.border, lineWidth: borderWidth)
        )
    }
}

struct ChildCell_Previews: PreviewProvider {
    @State static var state: ChildCellState = .connected
    static var previews: some View {
        ChildCell(name: "Emma", grade: .third, state: $state) { }
    }
}
