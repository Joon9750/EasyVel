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
    
    var storageListOutput = PublishRelay<([StorageDTO], [String])>()
    
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
                    self?.realm.getFolderImage(folderName: $0 ?? "") ?? ""
                }
                self?.storageListOutput.accept((folderList, folderImageList))
            })
            .disposed(by: disposeBag)
    }
}
