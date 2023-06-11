//
//  PostScrapButtonDidTapped.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/31.
//

import Foundation

protocol PostScrapButtonDidTapped: AnyObject {
    func scrapButtonDidTapped(storagePost: StoragePost, isScrapped: Bool, cellIndex: Int)
}
