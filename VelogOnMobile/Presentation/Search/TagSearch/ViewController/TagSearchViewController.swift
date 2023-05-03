//
//  KeywordSearchViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/30.
//

import UIKit

final class TagSearchViewController: BaseViewController {
    
    private let searchView = TagSearchView()
    private var viewModel: TagSearchViewModelInputOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonAction()
    }
    
    init(viewModel: TagSearchViewModel) {
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
    
    private func bind() {
        viewModel?.tagAddStatus = { [weak self] isSuccess, statusText in
            switch isSuccess {
            case true:
                self?.searchView.addStatusLabel.textColor = .brandColor
                self?.searchView.addStatusLabel.text = statusText
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self?.searchView.addStatusLabel.text = ""
                }
            case false:
                self?.searchView.addStatusLabel.textColor = .red
                self?.searchView.addStatusLabel.text = statusText
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self?.searchView.addStatusLabel.text = ""
                }
            }
        }
    }
}

private extension TagSearchViewController {
    func setButtonAction() {
        searchView.dismissBtn.addTarget(self, action: #selector(dismissButtonAction), for: .touchUpInside)
        searchView.addTagBtn.addTarget(self, action: #selector(addTagButtonAction), for: .touchUpInside)
    }
    
    @objc
    func dismissButtonAction() {
        self.dismiss(animated: true)
    }
    
    @objc
    func addTagButtonAction() {
        if let tag = searchView.textField.text {
            if tag != "" {
                viewModel?.tagAddButtonDidTap(tag: tag)
            }
        }
    }
}
