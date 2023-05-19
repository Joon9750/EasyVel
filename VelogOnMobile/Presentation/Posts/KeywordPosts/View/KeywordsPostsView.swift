//
//  KeywordsView.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/01.
//

import UIKit

import SnapKit

final class KeywordsPostsView: BaseUIView {
    
    let keywordsTableView = KeywordsTableView(frame: .null, style: .insetGrouped)
    let keywordsPostsViewExceptionView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.emptyPostsList
        imageView.isHidden = true
        return imageView
    }()
    
    override func render() {
        self.addSubviews(
            keywordsTableView,
            keywordsPostsViewExceptionView
        )
        
        keywordsTableView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(180)
            $0.leading.trailing.bottom.equalToSuperview()
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
