//
//  DeviceModel.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 29.06.23.
//

import SwiftUI

enum DeviceType: String {
    case iOS = "iOS"
    case iPad = "iPad"
    
    var modelName: String {
        switch self {
        case .iOS:
            return "iOS"
        case .iPad:
            return "iOS"
        }
    }
    
    var image: Image {
        switch self {
        case .iOS:
            return .Device.iPhone
        case .iPad:
            return .Device.iPad
        }
    }
}

struct DeviceModel {
    
    let deviceName: String
    let deviceToken: String
    let deviceType: DeviceType
    let id: Int
    
    init(dto: DeviceDto) {
        deviceName = dto.deviceName ?? ""
        deviceToken = dto.deviceToken ?? ""
        if let type = DeviceType(rawValue: dto.deviceType ?? "") {
            deviceType = type
        } else {
            deviceType = (dto.deviceName ?? "").contains("iPad") ?
            DeviceType.iPad :
            DeviceType.iOS
        }
        id = dto.id
    }
}
