//
//  SettingViewModel.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/06/18.
//

import UIKit

import RxSwift
import RxRelay

final class SettingViewModel: BaseViewModel {
    
    let realm = RealmService()
    
    // MARK: - Output
    
    
    // MARK: - Input
    
    let signOutCellDidTouched = PublishRelay<Bool>()
    let withdrawalCellDidTouched = PublishRelay<Bool>()
    
    // MARK: - init
    
    override init() {
        super.init()
        makeOutput()
    }
    
    private func makeOutput() {
        signOutCellDidTouched
            .subscribe(onNext: { [weak self] didTouched in
                if didTouched {
                    self?.realm.setAutoSignIn(didSignIn: false)
                }
            })
            .disposed(by: disposeBag)
        
        withdrawalCellDidTouched
            .subscribe(onNext: { [weak self] didTouched in
                if didTouched {
                }
            })
            .disposed(by: disposeBag)
    }
}
