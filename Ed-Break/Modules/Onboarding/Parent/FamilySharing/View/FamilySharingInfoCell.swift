//
//  FamilySharingInfoCell.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 30.09.22.
//

import SwiftUI

struct FamilySharingInfoCell: View {
    
    let type: FamilySharingInfoCellType
    @Environment(\.openURL) var openURL
    
    private let imageWidth = 10.0
    private let imageSpacing = 10.0
    
    var body: some View {
        Button {
            openURL(type.url)
        } label: {
            HStack(spacing: imageSpacing) {
                type.image.frame(width: imageWidth, height: imageWidth)
                Text(LocalizedStringKey(type.title)).font(.appHeadline)
            }.foregroundColor(.link)
        }
    }
}

struct FamilySharingInfoCell_Previews: PreviewProvider {
    static var previews: some View {
        FamilySharingInfoCell(type: .setup)
    }
}

enum FamilySharingInfoCellType: CaseIterable {
    
    case setup, appleId
    
    var image: Image {
        switch self {
        case .setup:    return Image.FamilySharing.info
        case .appleId:  return Image.FamilySharing.info
        }
    }
    
    var title: String {
        switch self {
        case .setup:    return "familySharing.setup.title"
        case .appleId:  return "familySharing.appleId.title"
        }
    }
    
    var url: URL {
        switch self {
        case .setup:    return URL(string: "https://support.apple.com/HT201088")!
        case .appleId:  return URL(string: "https://support.apple.com/HT201084")!
        }
    }
}

