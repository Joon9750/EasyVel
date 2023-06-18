//
//  MyPageViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//

import UIKit

import RxSwift


final class SettingViewController: RxBaseViewController<SettingViewModel> {

    private let settingView = SettingView()
    
    override func render() {
        self.view = settingView
    }
    
    override func configUI() {
        view.backgroundColor = .white
    }
    
    override func bind(viewModel: SettingViewModel) {
        super.bind(viewModel: viewModel)
        bindOutput(viewModel)
        
        settingView.tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel?.logoutCellDidTouched.accept(true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(_ viewModel: SettingViewModel) {
        
    }
}
