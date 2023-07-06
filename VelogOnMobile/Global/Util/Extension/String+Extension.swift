//
//  String+Extension.swift
//  VelogOnMobile
//
//  Created by 장석우 on 2023/06/02.
//

import UIKit

extension String {
    var checkEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }

    var checkPassword: Bool {
        guard self.count > 8 else { return false }
        return true
    }
    
    var isNotEmpty: Bool {
        return self.isEmpty ? false : true
    }
    
    var isValidText: Bool {
        return !self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}


extension String {
    /// Label안에 Image를 넣을때 적절한 String타입으로 만들어주는 함수
    /// - Returns: Label을 리턴해줌
    func makeNSAttributedString() -> NSAttributedString {
        return NSAttributedString(string: self)
    }
}

extension String {
    
    /// String의 너비를 반환해주는 함수
    /// - Parameter addPadding: padding값을 더해줄때 사용(기본값 0)
    /// - Returns: string의 너비값(실제로는 string을 넣은 label의 너비값)
    func calcuateWidth(font: UIFont, addPadding: CGFloat = 0) -> CGFloat {
        let label = UILabel()
        label.text = self
        label.font = font
        label.sizeToFit()
        return label.frame.width + addPadding
    }
}

