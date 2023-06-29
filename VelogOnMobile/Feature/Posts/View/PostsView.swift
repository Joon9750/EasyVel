//
//  KeywordsView.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/01.
//

import UIKit

import SnapKit

final class PostsView: BaseUIView {
    
    let postsTableView = PostsTableView(frame: .null, style: .insetGrouped)
    let keywordsPostsViewExceptionView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.emptyPostsList
        imageView.isHidden = true
        return imageView
    }()
    
    override func render() {
        self.addSubviews(
            postsTableView,
            keywordsPostsViewExceptionView
        )
        
        postsTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        keywordsPostsViewExceptionView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(166)
            $0.width.equalTo(150)
        }
    }
    
    override func configUI() {
        self.backgroundColor = .white
    }
}
