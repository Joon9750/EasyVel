//
//  KeywordSearchViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/30.
//

import UIKit

import RxSwift
import RxCocoa

final class TagSearchViewController: RxBaseViewController<TagSearchViewModel> {
    
    private let searchView = TagSearchView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonAction()
    }

    override func render() {
        self.view = searchView
    }
    
    override func bind(viewModel: TagSearchViewModel) {
        super.bind(viewModel: viewModel)
        bindOutput(viewModel)
         
        searchView.addTagBtn.rx.tap
            .flatMap { [weak self] _ -> Observable<String> in
                if let text = self?.searchView.textField.text {
                    return .just(text)
                } else {
                    return .empty()
                }
            }
            .bind(to: viewModel.tagAddButtonDidTap)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(_ viewModel: TagSearchViewModel) {
        viewModel.tagAddStatusOutput
            .asDriver(onErrorJustReturn: (false, ""))
            .drive(onNext: { [weak self] isSuccess, statusText in
                switch isSuccess {
                case true:
                    self?.searchView.addStatusLabel.textColor = .brandColor
                    self?.searchView.addStatusLabel.text = statusText
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self?.searchView.addStatusLabel.text = TextLiterals.noneText
                    }
                case false:
                    self?.searchView.addStatusLabel.textColor = .red
                    self?.searchView.addStatusLabel.text = statusText
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self?.searchView.addStatusLabel.text = TextLiterals.noneText
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}

private extension TagSearchViewController {
    func setButtonAction() {
        searchView.dismissBtn.addTarget(self, action: #selector(dismissButtonAction), for: .touchUpInside)
    }
    
    @objc
    func dismissButtonAction() {
        self.dismiss(animated: true)
    }
}
