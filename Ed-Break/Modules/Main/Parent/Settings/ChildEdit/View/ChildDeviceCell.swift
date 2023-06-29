//
//  ChildDeviceCell.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 29.06.23.
//


import SwiftUI

struct ChildDeviceCell: View {
    
    let device: DeviceModel
    
    private let imageHeight = 42.0
    private let padding = 16.0
    private let cornerRadius = 12.0
    private let borderWidth = 1.0
    private let spacing = 10.0
    private let labelHeight = 30.0
    
    var body: some View {
        HStack(spacing: spacing) {
            device.deviceType.image
            VStack(alignment: .leading) {
                Text(device.deviceName)
                    .font(.appButton)
                Text(device.deviceType.modelName)
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

struct ChildDeviceCell_Previews: PreviewProvider {
    static var previews: some View {
        ChildDeviceCell(
            device: DeviceModel(
                dto: DeviceDto(
                    deviceName: "Emma's iPhone",
                    deviceToken: "emma_token",
                    deviceType: "iOS",
                    id: 1
                )
            )
        )
    }
}
