//
//  ScrapStorageViewModel.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/29.
//

import Foundation

import RxRelay
import RxSwift
import RealmSwift

final class ScrapStorageViewModel: BaseViewModel {
    
    let realm = RealmService()
    
    // MARK: - Output
    
    var storageListOutput = PublishRelay<([StorageDTO], [String], [Int])>()
    var alreadyHaveFolderNameRelay = PublishRelay<Bool>()
    
    // MARK: - Input
    
    var addFolderInput = PublishRelay<String>()
    
    override init() {
        super.init()
        makeOutput()
    }
    
    private func makeOutput() {
        viewWillAppear
            .flatMapLatest( { [weak self] _ -> Observable<[StorageDTO]> in
                guard let scrapFolderRealmDTO: Results<ScrapStorageDTO> = self?.realm.getFolders() else { return Observable.empty() }
                let scrapFolder = self?.realm.convertToStorageDTO(input: scrapFolderRealmDTO)
                return Observable<[StorageDTO]>.just(scrapFolder ?? [StorageDTO]())
            })
            .subscribe(onNext: { [weak self] folderList in
                let folderNameList = folderList.map { $0.folderName }
                let folderImageList = folderNameList.map {
                    self?.realm.getFolderImage(folderName: $0 ?? "") ?? String()
                }
                let folderPostsCount = folderNameList.map {
                    self?.realm.getFolderPostsCount(folderName: $0 ?? "") ?? Int()
                }
                self?.storageListOutput.accept((folderList, folderImageList, folderPostsCount))
            })
            .disposed(by: disposeBag)
        
        addFolderInput
            .subscribe(onNext: { [weak self] folderName in
                let storageDTO: StorageDTO = StorageDTO(
                    articleID: UUID(),
                    folderName: folderName,
                    count: 0
                )
                if self?.realm.checkUniqueFolder(input: storageDTO) == true {
                    self?.realm.addFolder(item: storageDTO)
                    guard let scrapFolderRealmDTO: Results<ScrapStorageDTO> = self?.realm.getFolders() else { return }
                    let scrapFolder = self?.realm.convertToStorageDTO(input: scrapFolderRealmDTO)
                    let folderNameList = scrapFolder.map {
                        $0.map {
                            $0.folderName
                        }
                    }
                    let folderImageList = folderNameList.map {
                        $0.map {
                            self?.realm.getFolderImage(folderName: $0 ?? "") ?? String()
                        }
                    }
                    let folderPostsCount = folderNameList.map {
                        $0.map {
                            self?.realm.getFolderPostsCount(folderName: $0 ?? "") ?? Int()
                        }
                    }
                    if let scrapFolder = scrapFolder,
                       let folderImageList = folderImageList,
                       let folderPostsCount = folderPostsCount {
                        self?.storageListOutput.accept((scrapFolder, folderImageList, folderPostsCount))
                    }
                } else {
                    self?.alreadyHaveFolderNameRelay.accept(true)
                }
            })
            .disposed(by: disposeBag)
    }
}
