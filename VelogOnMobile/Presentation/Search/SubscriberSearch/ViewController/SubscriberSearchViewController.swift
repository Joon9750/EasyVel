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
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func render() {
        self.view = searchView
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel?.viewWillDisappear()
    }
    
    private func bind() {
        viewModel?.subscriberAddStatus = { [weak self] isSuccess, statusText in
            switch isSuccess {
            case true:
                self?.searchView.searchStatusLabel.textColor = .brandColor
                self?.searchView.searchStatusLabel.text = statusText
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self?.searchView.searchStatusLabel.text = TextLiterals.noneText
                }
            case false:
                self?.searchView.searchStatusLabel.textColor = .red
                self?.searchView.searchStatusLabel.text = statusText
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self?.searchView.searchStatusLabel.text = TextLiterals.noneText
                }
            }
        }
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
            if tag != TextLiterals.noneText {
                viewModel?.subscriberAddButtonDidTap(name: tag)
            }
        }
    }
}
