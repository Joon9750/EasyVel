//
//  SubscribePostsViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//

import UIKit

final class SubscribePostsViewController: BaseViewController {

    private let subscribersPostsView = SubscribersPostsView()
    
    override func render() {
        self.view = subscribersPostsView
    }
}
