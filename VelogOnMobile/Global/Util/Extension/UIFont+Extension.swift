//
//  UIFont+Extension.swift
//  VelogOnMobile
//
//  Created by 장석우 on 2023/06/02.
//

import UIKit

extension UIFont {
    
    static func appleGothicNeo(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Apple SD Gothic Neo", size: size)!
    }
    
    static func avenir(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Avenir-Black", size: size)!
    }
    
    static var display: UIFont {
        return UIFont(size: 26, weight: .bold)
    }
    static var headline: UIFont {
        return UIFont(size: 20, weight: .bold)
    }
    static var subhead: UIFont {
        return UIFont(size: 18, weight: .medium)
    }
    static var body_2_B: UIFont {
        return UIFont(size: 16, weight: .bold)
    }
    static var body_2_M: UIFont {
        return UIFont(size: 16, weight: .medium)
    }
    static var body_1_B: UIFont {
        return UIFont(size: 14, weight: .bold)
    }
    static var body_1_M: UIFont {
        return UIFont(size: 14, weight: .medium)
    }
    static var caption_1_B: UIFont {
        return UIFont(size: 12, weight: .bold)
    }
    static var caption_1_M: UIFont {
        return UIFont(size: 12, weight: .medium)
    }
}

extension UIFont {
    convenience init(size fontSize: CGFloat, weight: UIFont.Weight) {
        let familyName = "Pretendard"

        var weightString: String
        switch weight {
        case .black:
            weightString = "Black"
        case .bold:
            weightString = "Blod"
        case .heavy:
            weightString = "ExtraBold"
        case .ultraLight:
            weightString = "ExtraLight"
        case .light:
            weightString = "Light"
        case .medium:
            weightString = "Medium"
        case .regular:
            weightString = "Regular"
        case .semibold:
            weightString = "SemiBold"
        case .thin:
            weightString = "Thin"
        default:
            weightString = "Regular"
        }
        
        let fontName = "\(familyName)-\(weightString)"
        if let font = UIFont(name: fontName, size: fontSize) {
            self.init(name: font.fontName, size: font.pointSize)!
        } else {
            self.init(size: fontSize, weight: weight)
        }
    }
}
