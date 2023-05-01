//
//  ListView.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/01.
//

import UIKit

import SnapKit

final class ListView: BaseUIView {
    private let subscriberListTableView = ListTableView(frame: CGRect.zero, style: .insetGrouped)
    let postsHeadView = ListHeadView()
    
    override func render() {
        self.addSubviews(
            subscriberListTableView,
            postsHeadView
        )
        
        postsHeadView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(120)
        }
        
        subscriberListTableView.snp.makeConstraints {
            $0.top.equalTo(postsHeadView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
