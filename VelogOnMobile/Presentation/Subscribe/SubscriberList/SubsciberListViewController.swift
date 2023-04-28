//
//  SubsciberListViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//

import UIKit

final class SubscriberListViewController: BaseViewController {
    
    private let subscriberListTableView = ListTableView()
    
    override func render() {
        self.view = subscriberListTableView
    }
}
