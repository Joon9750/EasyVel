//
//  ScrapFolderBottomSheetViewModel.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/28.
//

import Foundation

import RxRelay
import RxSwift

final class ScrapFolderBottomSheetViewModel: BaseViewModel {
    
    // MARK: - Output
    
    var folderNameListRelay = PublishRelay<[String]>()
    
    override init() {
        super.init()
        makeOutput()
    }
    
    private func makeOutput() {
        viewWillAppear
            .flatMapLatest( { [weak self] _ -> Observable<[String]> in
//                guard let self = self else { return Observable.empty() }
                return Observable<[String]>.just(["aa","bb","cc"])
            })
            .subscribe(onNext: { [weak self] folderList in
                self?.folderNameListRelay.accept(folderList)
            })
            .disposed(by: disposeBag)
    }
}
