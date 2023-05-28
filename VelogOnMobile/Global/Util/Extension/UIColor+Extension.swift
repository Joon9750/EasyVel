//
//  UIColor+Extension.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//

import UIKit

extension UIColor {
    static var brandColor: UIColor {
        return UIColor(hex: "#1EC897")
    }
    static var grayColor: UIColor {
        return UIColor(hex: "#EEEEEE")
    }
    static var lightGrayColor: UIColor {
        return UIColor(hex: "#EBEBEB")
    }
    static var darkGrayColor: UIColor {
        return UIColor(hex: "#585858")
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)
    }
}
