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
    
    let realm = RealmService()
    
    // MARK: - Output
    
    var folderNameListRelay = PublishRelay<[String]>()
    
    override init() {
        super.init()
        makeOutput()
    }
    
    private func makeOutput() {
        viewWillAppear
            .flatMapLatest( { [weak self] _ -> Observable<[String]> in
                var folderNameList: [String] = [String]()
                if let folderListRealmDTO = self?.realm.getFolders() {
                    let folderList = self?.realm.convertToStorageDTO(input: folderListRealmDTO)
                    folderNameList = folderList?.map { $0.folderName ?? String() } ?? [String]()
                }
                return Observable<[String]>.just(folderNameList)
            })
            .subscribe(onNext: { [weak self] folderList in
                self?.folderNameListRelay.accept(folderList)
            })
            .disposed(by: disposeBag)
    }
}
