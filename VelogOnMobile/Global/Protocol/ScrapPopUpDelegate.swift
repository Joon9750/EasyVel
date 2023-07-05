//
//  ScrapPopUpDelegate.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/29.
//

import Foundation

protocol ScrapPopUpDelegate {
    func scrapBookButtonTapped()
    func folderButtonTapped(scrapPost: StoragePost)
}
