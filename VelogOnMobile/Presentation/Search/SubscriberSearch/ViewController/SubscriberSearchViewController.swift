//
//  SubscriberSearchViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//

import UIKit

final class SubscriberSearchViewController: BaseViewController {
    
    private let searchView = SubscriberSearchView()
    private var viewModel: SubscriberSearchViewModelInputOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonAction()
    }
    
    init(viewModel: SubscriberSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func render() {
        self.view = searchView
    }
}

private extension SubscriberSearchViewController {
    func setButtonAction() {
        searchView.dismissBtn.addTarget(self, action: #selector(dismissButtonAction), for: .touchUpInside)
        searchView.addSubscriberBtn.addTarget(self, action: #selector(addSubscribeButtonAction), for: .touchUpInside)
    }
    
    @objc
    func dismissButtonAction() {
        self.dismiss(animated: true)
    }
    
    @objc
    func addSubscribeButtonAction() {
        if let tag = searchView.textField.text {
            if tag != "" {
                viewModel?.subscriberAddButtonDidTap(name: tag)
            }
        }
    }
}
