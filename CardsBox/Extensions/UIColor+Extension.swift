//
//  UIColor+Extension.swift
//  CardsBox
//
//  Created by Eugene Shapovalov on 8/13/21.
//

import UIKit
import SwiftUI

extension Color {
    static let mainSkyBlue = Color(UIColor(hexString: "#86A8E7"))
    static let imperialRed = Color(UIColor(hexString: "#e63946"))
    static let honeydew = Color(UIColor(hexString: "#F1FAEE"))
    static let powderBlue = Color(UIColor(hexString: "#A8DADC"))
    static let celadonBlue = Color(UIColor(hexString: "#457B9D"))
    static let prussianBlue = Color(UIColor(hexString: "#1D3557"))
    static let grayBackgroundView = Color(.systemGray6)
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        let red   = CGFloat(r) / 255
        let green = CGFloat(g) / 255
        let blue  = CGFloat(b) / 255
        let alpha = CGFloat(a) / 255

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
