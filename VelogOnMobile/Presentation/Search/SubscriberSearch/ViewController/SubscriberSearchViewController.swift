//
//  SubscriberSearchViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//

import UIKit

import RxSwift
import RxCocoa

final class SubscriberSearchViewController: RxBaseViewController<SubscriberSearchViewModel> {
    
    private let searchView = SubscriberSearchView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonAction()
    }
    
    override func render() {
        self.view = searchView
    }

    override func bind(viewModel: SubscriberSearchViewModel) {
        super.bind(viewModel: viewModel)
        bindOutput(viewModel)
        
        searchView.addSubscriberBtn.rx.tap
            .flatMap { [weak self] _ -> Observable<String> in
                if let text = self?.searchView.textField.text {
                    return .just(text)
                } else {
                    return .empty()
                }
            }
            .bind(to: viewModel.subscriberAddButtonDidTap)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(_ viewModel: SubscriberSearchViewModel) {
        viewModel.subscriberAddStatusOutput
            .asDriver(onErrorJustReturn: (false, ""))
            .drive(onNext: { [weak self] isSuccess, statusText in
                switch isSuccess {
                case true:
                    self?.searchView.searchStatusLabel.textColor = .brandColor
                    self?.searchView.searchStatusLabel.text = statusText
                    self?.updateStatusLabel(text: statusText)
                case false:
                    self?.searchView.searchStatusLabel.textColor = .red
                    self?.searchView.searchStatusLabel.text = statusText
                    self?.updateStatusLabel(text: statusText)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func updateStatusLabel(text: String) {
        searchView.searchStatusLabel.text = text
        delayCompletable(1.5)
            .asDriver(onErrorJustReturn: ())
            .drive(onCompleted: { [weak self] in
                self?.searchView.searchStatusLabel.text = TextLiterals.noneText
            })
            .disposed(by: disposeBag)
    }
    
    private func delayCompletable(_ seconds: TimeInterval) -> Observable<Void> {
        return Observable<Void>.just(())
                .delay(.seconds(Int(seconds)), scheduler: MainScheduler.instance)
    }
}

private extension SubscriberSearchViewController {
    func setButtonAction() {
        searchView.dismissBtn.addTarget(self, action: #selector(dismissButtonAction), for: .touchUpInside)
    }
    
    @objc
    func dismissButtonAction() {
        self.dismiss(animated: true)
    }
}
