//
//  ImageLiterals.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//

import UIKit

enum ImageLiterals {
    
    // MARK: - tabBar
    
    static var homeTabIcon: UIImage { .load(name: "homeIcon") }
    static var listTabIcon: UIImage { .load(name: "listIcon") }
    static var unSaveBookMarkIcon: UIImage { .load(name: "bookmarkUnsave") }
    static var settingTabIcon: UIImage { .load(name: "settingIcon") }
    
    // MARK: - icon
    
    static var saveBookMarkIcon: UIImage { .load(name: "bookmarkSave") }
    static var searchIcon: UIImage { .load(name: "search") }
    static var plusFolder: UIImage { .load(name: "plusFolder") }
    
    // MARK: - Exception
    
    static var emptyAlarm: UIImage { .load(name: "emptyAlarm") }
    static var emptyPostsList: UIImage { .load(name: "emptyPostsList") }
    static var emptyKeywordList: UIImage { .load(name: "emptyKeywordList") }
    static var networkFail: UIImage { .load(name: "networkFail") }
}

extension UIImage {
    static func load(name: String) -> UIImage {
        guard let image = UIImage(named: name, in: nil, compatibleWith: nil) else {
            return UIImage()
        }
        image.accessibilityIdentifier = name
        return image
    }
    
    static func load(systemName: String) -> UIImage {
        guard let image = UIImage(systemName: systemName, compatibleWith: nil) else {
            return UIImage()
        }
        image.accessibilityIdentifier = systemName
        return image
    }
}