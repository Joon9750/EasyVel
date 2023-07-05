//
//  ImageLiterals.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//

import UIKit

enum ImageLiterals {
    
    // MARK: - sign in
    
    static var signInViewImage: UIImage { .load(name: "signInIcon") }
    
    // MARK: - tabBar
    
    static var home: UIImage { .load(name: "home") }
    static var homeFill: UIImage { .load(name: "home.fill") }
    static var list: UIImage { .load(name: "list") }
    static var listFill: UIImage { .load(name: "list.fill") }
    static var bookMark: UIImage { .load(name: "bookmark") }
    static var bookMarkFill: UIImage { .load(name: "bookmark.fill") }
    static var my: UIImage { .load(name: "my") }
    static var myFill: UIImage { .load(name: "my.fill") }
    
    // MARK: - icon
    
    static var searchIcon: UIImage { .load(name: "search") }
    static var plusFolder: UIImage { .load(name: "plusFolder") }
    static var activePlusFolder: UIImage { .load(name: "activePlusFolder") }
    static var scrapFolderIcon: UIImage { .load(name: "scrapFolderIcon") }
    static var plusIcon: UIImage { .load(name: "plus") }
    static var subscriberAddIcon: UIImage { .load(name: "addIcon" )}
    static var subscriberImage: UIImage { .load(name: "subscriberImage" )}
    static var tagPlusIcon: UIImage { .load(name: "tagPlusIcon") }
    static var xMarkIcon: UIImage { .load(name: "xmark") }
    static var viewPopButtonIcon: UIImage { .load(name: "viewPopButtonIcon") }
    static var alertIcon: UIImage { .load(name: "alert") }
    
    // MARK: - Exception
    
    static var emptyAlarm: UIImage { .load(name: "emptyAlarm") }
    static var emptyPostsList: UIImage { .load(name: "emptyPostsList") }
    static var emptyKeywordList: UIImage { .load(name: "emptyKeywordList") }
    static var networkFail: UIImage { .load(name: "networkFail") }
    static var subscriberListException: UIImage { .load(name: "subscriberListException") }
    static var serverFailImage: UIImage { .load(name: "serverFailImage") }
    static var webViewException: UIImage { .load(name: "webViewException") }
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
