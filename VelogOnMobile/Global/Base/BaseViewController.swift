//
//  BaseViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        configUI()
        setupNavigationBar()
        setupNavigationPopGesture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func render() {}
    
    func configUI() {
        view.backgroundColor = .white
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.topItem?.title = TextLiterals.noneText
    }
    
    func setupNavigationPopGesture() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
}
