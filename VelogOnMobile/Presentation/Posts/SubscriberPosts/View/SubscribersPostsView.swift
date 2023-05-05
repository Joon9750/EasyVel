//
//  SubscribersPostsView.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/01.
//

import UIKit

import SnapKit

final class SubscribersPostsView: BaseUIView {
    
    let postTableView = PostsTableView(frame: .null, style: .insetGrouped)
    
    override func render() {
        self.addSubview(postTableView)
        
        postTableView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(180)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
