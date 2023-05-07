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
    let moveToTopButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.backgroundColor = .brandColor
        button.alpha = 0.8
        button.isHidden = true
        button.setImage(UIImage(systemName: "arrow.uturn.up")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    override func render() {
        self.addSubviews(
            postTableView,
            moveToTopButton
        )
        
        postTableView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(180)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        moveToTopButton.snp.makeConstraints {
            $0.height.width.equalTo(45)
            $0.bottom.trailing.equalToSuperview().inset(30)
        }
    }
}
