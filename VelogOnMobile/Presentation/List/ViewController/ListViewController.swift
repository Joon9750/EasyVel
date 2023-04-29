//
//  ListViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/30.
//

import UIKit

import SnapKit

final class ListViewController: BaseViewController {
    
    private let subscriberListTableView = ListTableView(frame: CGRect.zero, style: .insetGrouped)
    private let postsHeadView = ListHeadView()
    private let viewModel: ListViewModelInputOutput?
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func render() {
        view.addSubviews(
            subscriberListTableView,
            postsHeadView
        )
        
        postsHeadView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(120)
        }
        
        subscriberListTableView.snp.makeConstraints {
            $0.top.equalTo(postsHeadView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func configUI() {}
    
    override func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func bind() {
        self.postsHeadView.addButton.addTarget(self, action: #selector(presentActionSheet), for: .touchUpInside)
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
