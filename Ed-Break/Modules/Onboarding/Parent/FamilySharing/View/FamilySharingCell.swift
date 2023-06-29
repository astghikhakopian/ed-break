//
//  FamilySharingCell.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 30.09.22.
//

import SwiftUI

struct FamilySharingCell: View {
    
    let type: FamilySharingCellType
    
    private let imageWidth = 32.0
    private let imageSpacing = 14.0
    
    var body: some View {
        HStack(spacing: imageSpacing) {
            type.image.frame(width: imageWidth, height: imageWidth)
            VStack(alignment: .leading, spacing: 0) {
                Text(LocalizedStringKey(type.title))
                    .font(.appHeadline)
                if let description = type.description {
                    Text(LocalizedStringKey(description))
                        .font(.appBody)
                        .foregroundColor(.primaryDescription)
                }
            }
        }
    }
}

struct FamilySharingCell_Previews: PreviewProvider {
    static var previews: some View {
        FamilySharingCell(type: .familySharing)
    }
}

enum FamilySharingCellType: CaseIterable, Identifiable {
    var id: String { title }
    
    
    case settings, appleId, familySharing, addChild, returnBack,
     appleFamily, waitForInvite, confirmInvite
    
    var image: Image {
        switch self {
        case .settings:         return Image.FamilySharing.settings
        case .appleId:          return Image.FamilySharing.appleId
        case .familySharing:    return Image.FamilySharing.familySharing
        case .addChild:         return Image.FamilySharing.addChild
        case .returnBack:       return Image.FamilySharing.returnBack
        case .appleFamily:      return Image.FamilySharing.familySharing
        case .waitForInvite:    return Image.FamilySharing.addChild
        case .confirmInvite:    return Image.FamilySharing.familySharingConfirmed
        }
    }
    
    var title: String {
        switch self {
        case .settings:         return "familySharing.settings.title"
        case .appleId:          return "familySharing.appleId.title"
        case .familySharing:    return "familySharing.familySharing.title"
        case .addChild:         return "familySharing.addChild.title"
        case .returnBack:       return "familySharing.returnBack.title"
        case .appleFamily:      return "familySharing.appleFamily.title"
        case .waitForInvite:    return "familySharing.waitForInvite.title"
        case .confirmInvite:    return "familySharing.confirmInvite.title"
        }
    }
    
    var description: String? {
        switch self {
        case .settings:         return nil
        case .appleId:          return "familySharing.appleId.description"
        case .familySharing:    return "familySharing.familySharing.description"
        case .addChild:         return nil
        case .returnBack:       return nil
        case .appleFamily:      return nil
        case .waitForInvite:    return "familySharing.waitForInvite.description"
        case .confirmInvite:    return nil
        }
    }
}
