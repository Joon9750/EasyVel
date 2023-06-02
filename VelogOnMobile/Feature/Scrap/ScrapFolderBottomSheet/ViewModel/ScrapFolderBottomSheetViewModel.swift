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
            .flatMap({ [weak self] _ -> Observable<[String]> in
                guard let folderListRealmDTO = self?.realm.getFolders() else {
                    return Observable.just([])
                }
                let folderList = self?.realm.convertToStorageDTO(input: folderListRealmDTO)
                let folderNameList = folderList?.map { $0.folderName ?? "" }
                return Observable.just(folderNameList ?? [String]())
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
                    var folders = [StorageDTO]()
                    if let foldersDTO = self?.realm.getFolders() {
                        folders = self?.realm.convertToStorageDTO(input: foldersDTO) ?? [StorageDTO]()
                    }
                    let scrapFoldersName = folders.map { $0.folderName ?? String() }
                    self?.folderNameListRelay.accept(scrapFoldersName)
                } else {
                    self?.alreadyHaveFolderNameRelay.accept(true)
                }
            })
            .disposed(by: disposeBag)
    }
}
