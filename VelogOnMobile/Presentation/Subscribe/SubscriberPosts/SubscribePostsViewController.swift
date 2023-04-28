//
//  SubscribePostsViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//

import UIKit

class SubscribePostsViewController: BaseViewController {

    private let postsTableView = PostsTableView()
    
    override func render() {
        self.view = postsTableView
    }
}
