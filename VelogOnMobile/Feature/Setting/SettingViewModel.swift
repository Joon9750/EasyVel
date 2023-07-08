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
    let didWithdrawalSuccess = PublishRelay<Bool>()
    
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
                    self?.realm.setAccessToken(accessToken: "")
                }
            })
            .disposed(by: disposeBag)
        
        withdrawalCellDidTouched
            .flatMapLatest { [weak self] didTouched -> Observable<Bool> in
                if didTouched {
                    let accessToken = self?.realm.getAccessToken()
                    let signOutRequest = SignOutRequest(accessToken: accessToken)
                    return self?.signOut(body: signOutRequest) ?? Observable.just(false)
                } else {
                    return Observable.just(false)
                }
            }
            .subscribe(onNext: { [weak self] didWithdrawalSuccess in
                if didWithdrawalSuccess {
                    self?.realm.deleteAllRealmData()
                    self?.didWithdrawalSuccess.accept(true)
                } else {
                    self?.didWithdrawalSuccess.accept(false)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - api

extension SettingViewModel {
    
    //MARK: - Fix Me: signOut 항상 참을 반환하는 오류
    
    func signOut(
        body: SignOutRequest
    ) -> Observable<Bool> {
        return Observable.create { observer in
            NetworkService.shared.signRepository.signOut() { [weak self] result in
                switch result {
                case .success(_):
                    observer.onNext(true)
                    observer.onCompleted()
                case .requestErr(_):
                    self?.serverFailOutput.accept(true)
                    observer.onError(NSError(domain: "requestErr", code: 0, userInfo: nil))
                default:
                    self?.serverFailOutput.accept(true)
                    observer.onError(NSError(domain: "UnknownError", code: 0, userInfo: nil))
                }
            }
            return Disposables.create()
        }
    }
}
