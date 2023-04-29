//
//  SubscribePostsViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//

import UIKit

import SnapKit

final class SubscribePostsViewController: BaseViewController {

    private let postsTableView = PostsTableView()
    
    override func render() {
        view.addSubview(postsTableView)
        
        postsTableView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(210)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
