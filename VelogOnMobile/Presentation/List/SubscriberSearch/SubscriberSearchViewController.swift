//
//  SubscriberSearchViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//

import UIKit

final class SubscriberSearchViewController: BaseViewController {
    
    private let searchView = SubscriberSearchView()
    
    override func render() {
        self.view = searchView
    }
}
