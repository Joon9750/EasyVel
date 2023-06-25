//
//  ListView.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/01.
//

import UIKit

import SnapKit

final class ListView: BaseUIView {
    let listTableView = ListTableView(frame: .null, style: .plain)
    let postsHeadView = ListHeadView()
    let ListViewExceptionView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.subscriberListException
        imageView.isHidden = true
        return imageView
    }()
    
    override func configUI() {
        self.backgroundColor = .gray100
    }
    
    override func render() {
        self.addSubviews(
            listTableView,
            postsHeadView,
            ListViewExceptionView
        )
        
        postsHeadView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(171)
        }
        self.bringSubviewToFront(postsHeadView)
        
        listTableView.snp.makeConstraints {
            $0.top.equalTo(postsHeadView.snp.bottom).offset(28)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        ListViewExceptionView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(360)
            $0.height.equalTo(168)
            $0.width.equalTo(190)
        }
    }
}
