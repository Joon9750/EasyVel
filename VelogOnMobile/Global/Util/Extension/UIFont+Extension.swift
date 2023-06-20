//
//  UIFont+Extension.swift
//  VelogOnMobile
//
//  Created by 장석우 on 2023/06/02.
//

import UIKit

extension UIFont {
    static var display: UIFont {
        return UIFont(name: "Pretendard-Bold", size: 26) ?? UIFont.systemFont(ofSize: 26, weight: .bold)
    }
    static var headline: UIFont {
        return UIFont(name: "Pretendard-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    static var subhead: UIFont {
        return UIFont(name: "Pretendard-Bold", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .medium)
    }
    static var body_2_B: UIFont {
        return UIFont(name: "Pretendard-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    static var body_2_M: UIFont {
        return UIFont(name: "Pretendard-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
    }
    static var body_1_B: UIFont {
        return UIFont(name: "Pretendard-Bold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .bold)
    }
    static var body_1_M: UIFont {
        return UIFont(name: "Pretendard-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    static var caption_1_B: UIFont {
        return UIFont(name: "Pretendard-Bold", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .bold)
    }
    static var caption_1_M: UIFont {
        return UIFont(name: "Pretendard-Medium", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .medium)
    }
}
