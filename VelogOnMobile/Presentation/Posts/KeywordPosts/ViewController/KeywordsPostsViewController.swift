//
//  KeywordsPostsViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/30.
//

import UIKit

final class KeywordsPostsViewController: BaseViewController {
    
    private let keywordsPostsView = KeywordsPostsView()
    
    override func render() {
        self.view = keywordsPostsView
    }
}
