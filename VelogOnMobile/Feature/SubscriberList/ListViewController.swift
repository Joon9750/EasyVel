//
//  ListViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/30.
//

import UIKit

import RxSwift
import RxRelay
import RxCocoa

final class ListViewController: RxBaseViewController<ListViewModel> {

    private let listView = ListView()
    
    override func render() {
        self.view = listView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNotification()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func bind(viewModel: ListViewModel) {
        super.bind(viewModel: viewModel)
        bindOutput(viewModel)
        
        listView.postsHeadView.searchSubscriberButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.searchSubcriberButtonTapped()
            })
            .disposed(by: disposeBag)
        
        listView.listTableView.rx.modelSelected(SubscriberListResponse.self).asObservable()
            .subscribe{ data in
                viewModel.subscriberTableViewCellDidTap.accept(data.name)
            }
            .disposed(by: disposeBag)
            
            
    }
    
    private func bindOutput(_ viewModel: ListViewModel) {
        viewModel.subscriberListOutput
            .asDriver(onErrorJustReturn: [])
            .drive(
                listView.listTableView.rx.items(cellIdentifier: ListTableViewCell.reuseIdentifier,
                                                   cellType: ListTableViewCell.self)
            ) { index, data, cell in
                cell.updateUI(data: data)
                cell.delegate = self
            }
            .disposed(by: disposeBag)
        
        viewModel.isListEmptyOutput
            .asDriver(onErrorJustReturn: Bool())
            .drive(onNext: { [weak self] isListEmpty in
                if isListEmpty {
                    self?.hiddenListTableView()
                } else {
                    self?.hiddenListExceptionView()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.subscriberUserMainURLOutput
            .asDriver(onErrorJustReturn: String())
            .drive(onNext: { [weak self] subscriberUserMainURL in
                self?.pushSubscriberUserMainViewController(userMainURL: subscriberUserMainURL)
            })
            .disposed(by: disposeBag)
        
        viewModel.presentUnsubscribeAlertOutput
            .asDriver(onErrorJustReturn: Bool())
            .drive { [weak self] bool in
                guard let self else { return } 
                let alertVC = VelogAlertViewController(alertType: .unsubscribe,
                                                       delegate: self)
                self.present(alertVC, animated: false)
            }
            .disposed(by: disposeBag)
    }

    func searchSubscriberViewWillDisappear() {
        self.viewModel?.refreshSubscriberList.accept(true)
    }
    
    private func hiddenListExceptionView() {
        listView.ListViewExceptionView.isHidden = true
        listView.listTableView.isHidden = false
    }
    
    private func hiddenListTableView() {
        listView.ListViewExceptionView.isHidden = false
        listView.listTableView.isHidden = true
    }
    
    private func searchSubcriberButtonTapped() {
        let viewModel = SubscriberSearchViewModel(subscriberList: viewModel?.subscriberList)
        let searchSubcriberViewController = SubscriberSearchViewController(viewModel: viewModel)
        viewModel.subscriberSearchDelegate = self
        searchSubcriberViewController.modalPresentationStyle = .pageSheet
        self.present(searchSubcriberViewController, animated: true)
    }
    
    private func pushSubscriberUserMainViewController(
        userMainURL: String
    ) {
        let webViewModel = WebViewModel(
            url: userMainURL
        )
        let webViewController = WebViewController(viewModel: webViewModel)
        webViewController.isPostWebView = false
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(scrollToTop),
            name: Notification.Name("scrollToTop"),
            object: nil
        )
    }
    
    @objc
    private func scrollToTop() {
        listView.listTableView.setContentOffset( .init(x: 0, y: -20), animated: true)
    }
}

extension ListViewController: SubscriberSearchProtocol {
    func searchSubscriberViewWillDisappear(
        subscriberList: [SubscriberListResponse]
    ) {
        self.viewModel?.subscriberList = subscriberList
    }
}

extension ListViewController: ListTableViewCellDelegate {
    func unsubscribeButtonDidTap(name: String) {
        viewModel?.unsubscriberButtonDidTap.accept(name)
    }
    
    
}

extension ListViewController: VelogAlertViewControllerDelegate {
    func yesButtonDidTap(_ alertType: AlertType) {
        viewModel?.deleteSubscribeEvent.accept(())
    }
    
    
}
