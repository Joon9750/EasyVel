//
//  SubsciberListViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//

import UIKit

import SnapKit

final class SubscriberListViewController: BaseViewController {
    
    private let subscriberListTableView = ListTableView()
    
    override func render() {
        view.addSubview(subscriberListTableView)
        
        subscriberListTableView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(210)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
