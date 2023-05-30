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
    let dummyDto4 = StorageDTO(articleID: 3,folderName: "iOS", count: 2)
    let dummyDto5 = StorageDTO(articleID: 4,folderName: "iOS", count: 2)
    let dummyDto6 = StorageDTO(articleID: 5,folderName: "iOS", count: 2)
    let dummyDto7 = StorageDTO(articleID: 6,folderName: "iOS", count: 2)
    let dummyDto8 = StorageDTO(articleID: 7,folderName: "iOS", count: 2)
    let dummyDto9 = StorageDTO(articleID: 8,folderName: "iOS", count: 2)
    
    var storageListOutput = PublishRelay<[StorageDTO]>()
    
    override init() {
        super.init()
        makeOutput()
    }
    
    private func makeOutput() {
        viewWillAppear
            .flatMapLatest( { [weak self] _ -> Observable<[StorageDTO]> in
                guard let self = self else { return Observable.empty() }
                return Observable<[StorageDTO]>.just([self.dummyDto1,self.dummyDto2,self.dummyDto3,self.dummyDto4,self.dummyDto5,self.dummyDto6,self.dummyDto7,self.dummyDto8,self.dummyDto9])
            })
            .subscribe(onNext: { [weak self] folderList in
                self?.storageListOutput.accept(folderList)
            })
            .disposed(by: disposeBag)
    }
}
