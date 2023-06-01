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
    
    // MARK: - Input
    
    var addNewFolderTitle = PublishRelay<String>()
    
    // MARK: - Output
    
    var folderNameListRelay = PublishRelay<[String]>()
    var alreadyHaveFolderNameRelay = PublishRelay<Bool>()
    
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
                    for index in 0 ..< (folderList?.count ?? Int()) {
                        folderNameList.append(folderList?[index].folderName ?? "")
                    }
                    return Observable<[String]>.just(folderNameList)
                }
                return Observable<[String]>.just(folderNameList)
            })
            .subscribe(onNext: { [weak self] folderList in
                self?.folderNameListRelay.accept(folderList)
            })
            .disposed(by: disposeBag)

        addNewFolderTitle
            .subscribe(onNext: { [weak self] folderName in
                let storageDTO: StorageDTO = StorageDTO(
                    articleID: UUID(),
                    folderName: folderName,
                    count: 0
                )
                if self?.realm.checkUniqueFolder(input: storageDTO) == true {
                    self?.realm.addFolder(item: storageDTO)
                } else {
                    self?.alreadyHaveFolderNameRelay.accept(true)
                }
            })
            .disposed(by: disposeBag)
    }
}
