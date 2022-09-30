//
//  Font.swift
//  Ed-Break
//
//  Created by Astghik Hakopian on 26.09.22.
//

import SwiftUI

enum FontType: String {
    case poppins
    
    var name: String {
        self.rawValue.capitalized
    }
}

enum FontWeight: String {
    
    case extraLight
    case light
    case thin
    case regular
    case medium
    case semiBold
    case bold
    case extraBold
    case black
    
    case extraLightItalic
    case lightItalic
    case thinItalic
    case regularItalic
    case mediumItalic
    case semiBoldItalic
    case boldItalic
    case extraBoldItalic
    case blackItalic
    
    var name: String {
        "-" + self.rawValue.capitalized
    }
}

extension Font {
    
    static private func font(type: FontType, weight: FontWeight, style: UIFont.TextStyle) -> Font {
        .custom(type.name + weight.name, size: UIFont.preferredFont(forTextStyle: style).pointSize)
    }
    
    static private func font(type: FontType, weight: FontWeight, size: CGFloat) -> Font {
        .custom(type.name + weight.name, size: size)
    }
}


extension Font {
    
    static let appLargeTitle = font(type: .poppins, weight: .bold, size: 21)
    static let appTitle = font(type: .poppins, weight: .bold, size: 19)
    static let appSecondaryTitle = font(type: .poppins, weight: .bold, style: .title2)
    static let appTertiaryTitle = font(type: .poppins, weight: .bold, style: .title3)
    static let appButton = font(type: .poppins, weight: .medium, size: 14)
    static let appHeadline = font(type: .poppins, weight: .medium, size: 13)
    static let appBody = font(type: .poppins, weight: .regular, size: 11)
    static let appCallout = font(type: .poppins, weight: .regular, style: .callout)
    static let appCaption = font(type: .poppins, weight: .regular, style: .caption1)
    static let appCredits = font(type: .poppins, weight: .light, style: .caption2)
}

