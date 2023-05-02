//
//  KeywordSearchViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/30.
//

import UIKit

final class TagSearchViewController: BaseViewController {
    
    private let searchView = KeywordSearchView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonAction()
    }
    
    override func render() {
        self.view = searchView
    }
}

private extension KeywordSearchViewController {
    func setButtonAction() {
        searchView.dismissBtn.addTarget(self, action: #selector(dismissButtonAction), for: .touchUpInside)
    }
    
    @objc
    func dismissButtonAction() {
        self.dismiss(animated: true)
    }
}
