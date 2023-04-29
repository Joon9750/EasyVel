//
//  KeywordSearchViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/30.
//

import UIKit

final class KeywordSearchViewController: BaseViewController {
    
    private let searchView = KeywordSearchView()
    
    override func render() {
        self.view = searchView
    }
}
