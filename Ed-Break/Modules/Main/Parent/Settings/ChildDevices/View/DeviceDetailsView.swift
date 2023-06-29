//
//  DeviceDetailsView.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 29.06.23.
//

import SwiftUI

struct DeviceDetailsView: View {
    
    let device: DeviceModel
    let deleteAction: (DeviceModel) -> Void
    
    @State private var showDeletingAlert: Bool = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    private let cornerRadius = 12.0
    private let spacing = 14.0
    private let padding = 20.0
    private let gap = 20.0
    
    var body: some View {
        MainBackground(title: "deviceDetails.title", withNavbar: true) {
            VStack(spacing: gap) {
                deviceView(device: device)
                deleteButton
            }
        }
        .alert(
            "main.parent.settings.delete.description",
            isPresented: $showDeletingAlert,
            actions: { alertDeleteButton },
            message: { Text("main.parent.settings.delete.description.details") }
        )
        .hiddenTabBar()
    }
}

private extension DeviceDetailsView {
    
    func deviceView(device: DeviceModel) -> some View {
        ZStack(alignment: .leading) {
            Color.primaryCellBackground
                .cornerRadius(cornerRadius)
                .shadow(color: .shadow, radius: 40, x: 0, y: 20)
            VStack(spacing: spacing) {
                device.deviceType.image
                    .resizable()
                    .frame(width: 80, height: 80)
                Text(device.deviceType.modelName)
                    .font(.appHeadline)
                    .foregroundColor(.primaryText)
                CommonTextField(
                    title: "deviceDetails.name",
                    placeHolder: device.deviceName, text: .constant("")
                )
                .disabled(true)
            }.padding(gap)
        }
    }
    
    private var deleteButton: some View {
        ZStack {
            Color.appWhite
            CancelButton(
                action: { showDeletingAlert = true },
                title: "childDetails.delete",
                color: .primaryRed,
                isContentValid: .constant(true)
            )
        }
        .cornerRadius(cornerRadius)
    }
    
    var alertDeleteButton: some View {
        Button(
            "common.delete",
            role: .destructive,
            action: {
                deleteAction(device)
                presentationMode.wrappedValue.dismiss()
            }
        )
    }
}

struct DeviceDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceDetailsView(
            device: DeviceModel(
                dto: DeviceDto(
                    deviceName: "",
                    deviceToken: "",
                    deviceType: "",
                    id: 1
                )
            ),
            deleteAction: { _ in }
        )
    }
}
