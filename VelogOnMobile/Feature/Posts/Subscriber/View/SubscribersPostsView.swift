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
        button.layer.borderColor = UIColor.lightGrayColor.cgColor
        button.backgroundColor = .lightGrayColor
        button.alpha = 0.8
        button.isHidden = true
        button.setImage(UIImage(systemName: "arrow.up")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    let keywordsPostsViewExceptionView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.emptyPostsList
        imageView.isHidden = true
        return imageView
    }()
    
    override func render() {
        self.addSubviews(
            postTableView,
            moveToTopButton,
            keywordsPostsViewExceptionView
        )
        
        postTableView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(180)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        moveToTopButton.snp.makeConstraints {
            $0.height.width.equalTo(45)
            $0.bottom.trailing.equalToSuperview().inset(30)
        }
        
        keywordsPostsViewExceptionView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(166)
            $0.width.equalTo(150)
        }
    }
    
    func subscriberPostViewDidScroll() {
        postTableView.snp.updateConstraints {
            $0.top.equalToSuperview().offset(50)
        }
    }
    
    func subscriberPostViewScrollDidEnd() {
        postTableView.snp.updateConstraints {
            $0.top.equalToSuperview().offset(180)
        }
    }
}
