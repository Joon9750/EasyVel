//
//  ScrapStorageViewModel.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/29.
//

import Foundation

import RxRelay
import RxSwift

final class ScrapStorageViewModel: BaseViewModel {
    
    // MARK: - Output
    
    let dummyDto1 = StorageDTO(articleID: 0,folderName: "iOS", count: 2)
    let dummyDto2 = StorageDTO(articleID: 1,folderName: "iOS", count: 2)
    let dummyDto3 = StorageDTO(articleID: 2,folderName: "iOS", count: 2)
    
    var storageListOutput = PublishRelay<[StorageDTO]>()
    
    override init() {
        super.init()
        makeOutput()
    }
    
    private func makeOutput() {
        viewWillAppear
            .flatMapLatest( { [weak self] _ -> Observable<[StorageDTO]> in
                guard let self = self else { return Observable.empty() }
                return Observable<[StorageDTO]>.just([self.dummyDto1,self.dummyDto2,self.dummyDto3])
            })
            .subscribe(onNext: { [weak self] folderList in
                self?.storageListOutput.accept(folderList)
            })
            .disposed(by: disposeBag)
    }
}
