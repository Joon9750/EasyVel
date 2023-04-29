//
//  KeywordsPostsViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/30.
//

import UIKit

import SnapKit

final class KeywordsPostsViewController: BaseViewController {

    private let keywordsTableView = KeywordsTableView()
    
    override func render() {
        view.addSubview(keywordsTableView)
        
        keywordsTableView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(210)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
