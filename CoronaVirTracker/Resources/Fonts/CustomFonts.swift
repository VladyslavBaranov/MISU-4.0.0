//
//  CustomFonts.swift
//  CoronaVirTracker
//
//  Created by Dmytro Kruhlov on 19.05.2022.
//  Copyright © 2022 CVTCompany. All rights reserved.
//

import SwiftUI

class CustomFonts {
    var name: Name = .inter
    var weight: Weight = .regular
    var size: CGFloat = 14
    
    var fontName: String {
        self.name.rawValue + "-" + self.weight.rawValue
    }
    
    var font: UIFont? {
        return UIFont(name: fontName, size: size)
    }
    
    var systemWeight: UIFont.Weight {
        switch weight {
        case .black:
            return .black
        case .bold:
            return .bold
        case .extraBold:
            return .heavy
        case .extraLight:
            return .ultraLight
        case .light:
            return .light
        case .medium:
            return .medium
        case .regular:
            return .regular
        case .semiBold:
            return .semibold
        case .thin:
            return .thin
        }
    }
    
    enum Name: String {
        case inter = "Inter"
    }
    
    enum Weight: String {
        case black = "Black"
        case bold = "Bold"
        case extraBold = "ExtraBold"
        case extraLight = "ExtraLight"
        case light = "Light"
        case medium = "Medium"
        case regular = "Regular"
        case semiBold = "SemiBold"
        case thin = "Thin"
    }
    
    init(name: Name = .inter, weight: Weight = .regular, size: CGFloat = 14) {
        self.name = name
        self.weight = weight
        self.size = size
    }
    
    init(name: Name = .inter, sysWeight: UIFont.Weight, size: CGFloat = 14) {
        self.name = name
        self.weight = sysWeight.customWeight
        self.size = size
    }
    
    static func createUIInter(weight: Weight = .regular, size: CGFloat = 14) -> UIFont {
        let fontObject = CustomFonts(name: .inter, weight: weight, size: size)
        return fontObject.font ?? .systemFont(ofSize: size)
    }
    
    static func createInter(weight: Weight = .regular, size: CGFloat = 14) -> Font {
        let fontObject = CustomFonts(name: .inter, weight: weight, size: size)
        return Font(fontObject.font ?? .systemFont(ofSize: size))
    }
}

extension UIFont.Weight {
    var customWeight: CustomFonts.Weight {
        switch self {
        case .black:
            return .black
        case .bold:
            return .bold
        case .heavy:
            return .extraBold
        case .ultraLight:
            return .extraLight
        case .light:
            return .light
        case .medium:
            return .medium
        case .regular:
            return .regular
        case .semibold:
            return .semiBold
        case .thin:
            return .thin
        default:
            return .regular
        }
    }
}
