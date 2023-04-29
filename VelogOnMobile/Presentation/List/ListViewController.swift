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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButtonAction()
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
    
    func addButtonAction() {
        postsHeadView.addButton.addTarget(self, action: #selector(addSubscriberSearchButton), for: .touchUpInside)
    }
    
    @objc
    func addSubscriberSearchButton() {
        let searchVC = SubscriberSearchViewController()
        searchVC.modalPresentationStyle = .pageSheet
        
        if let sheet = searchVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        present(searchVC, animated: true)
    }
}
