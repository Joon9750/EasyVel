//
//  ListViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/30.
//

import UIKit

final class ListViewController: BaseViewController {
    
    private let listView = ListView()
    private let viewModel: ListViewModelInputOutput?
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
    }
    
    override func render() {
        self.view = listView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func bind() {
        self.listView.postsHeadView.addButton.addTarget(self, action: #selector(presentActionSheet), for: .touchUpInside)
    }
}

// MARK: - button Action

private extension ListViewController {
    @objc
    func presentActionSheet() {
        let searchKeywordButtonAction = UIAlertAction(title: "Keyword", style: .default) { [weak self] action in
            self?.addKeywordButtonTap()
        }
        let searchSubscriberButtonAction = UIAlertAction(title: "Subscriber", style: .default) { [weak self] action in
            self?.addSubscriberButtonTap()
        }
        let cancelAction = UIAlertAction(title: "Canel", style: .cancel)
        let actionSheet = UIAlertController(title: "검색", message: "검색할 기준을 선택해주세요.", preferredStyle: .actionSheet)
        actionSheet.addAction(searchKeywordButtonAction)
        actionSheet.addAction(searchSubscriberButtonAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true)
    }
    
    func addKeywordButtonTap() {
        let keywordSearchVC = KeywordSearchViewController()
        keywordSearchVC.modalPresentationStyle = .pageSheet
        if let sheet = keywordSearchVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        present(keywordSearchVC, animated: true)
    }
    
    func addSubscriberButtonTap() {
        let subscriberSearchVC = SubscriberSearchViewController()
        subscriberSearchVC.modalPresentationStyle = .pageSheet
        if let sheet = subscriberSearchVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        present(subscriberSearchVC, animated: true)
    }
}
