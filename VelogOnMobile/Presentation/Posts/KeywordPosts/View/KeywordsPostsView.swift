//
//  KeywordsView.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/01.
//

import UIKit

import SnapKit

final class KeywordsPostsView: BaseUIView {
    
    let keywordsTableView = KeywordsTableView()
    
    override func render() {
        self.addSubview(keywordsTableView)
        
        keywordsTableView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(180)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
