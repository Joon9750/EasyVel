//
//  SignInViewModel.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/06/18.
//

import Foundation

import RxSwift
import RxRelay

final class SignInViewModel: BaseViewModel {
    let realm = RealmService()
    
    override init() {
        super.init()
        makeOutput()
    }
    
    private func makeOutput() {
        viewWillAppear
            .subscribe(onNext: { [weak self] in
                
                //MARK: - fix me
//                self?.realm.setAutoSignIn(didSignIn: true)
            })
            .disposed(by: disposeBag)
    }
}
