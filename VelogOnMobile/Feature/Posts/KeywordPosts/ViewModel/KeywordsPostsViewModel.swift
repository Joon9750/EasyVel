//
//  KeywordsPostsViewModel.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/03.
//

import Foundation

import RealmSwift
import RxRelay
import RxSwift

final class KeywordsPostsViewModel: BaseViewModel {
    
    let realm = RealmService()

    // MARK: - Input
    
    var cellScrapButtonDidTap = PublishRelay<(StoragePost, Bool)>()
    var tableViewReload = PublishRelay<Void>()

    // MARK: - Output
    
    var tagPostsListOutput = PublishRelay<GetTagPostResponse>()
    var isPostsEmptyOutput = PublishRelay<Bool>()
    var tagPostsListDidScrapOutput = PublishRelay<[Bool]>()
    
    override init() {
        super.init()
        makeOutput()
    }
    
    private func makeOutput() {
        viewWillAppear
            .startWith(LoadingView.showLoading())
            .flatMapLatest( { _ -> Observable<GetTagPostResponse> in
                //guard let self = self else { return Observable.empty() }
                return self.getTagPosts()
            })
            .map { [weak self] response -> (GetTagPostResponse, [Bool]) in
                let posts = response.tagPostDtoList ?? []
                let storagePosts = posts.map { self?.convertTagPostDtoListToStoragePost(input: $0) }
                let isScrapList = storagePosts.map {
                    self?.checkIsUniquePost(post: $0 ?? StoragePost(img: "", name: "", summary: "", title: "", url: "")) ?? false
                }
                return (response, isScrapList)
            }
            .subscribe(onNext: { [weak self] postList, isScrapList in
                self?.isPostsEmptyOutput.accept(self?.checkStorageEmpty(input: postList) ?? false)
                self?.tagPostsListOutput.accept(postList)
                self?.tagPostsListDidScrapOutput.accept(isScrapList)
                LoadingView.hideLoading()
            })
            .disposed(by: disposeBag)
        
        cellScrapButtonDidTap
            .subscribe(onNext: { [weak self] storagePost, isScrapped in
                LoadingView.hideLoading()
                if isScrapped == false {
                    self?.realm.addPost(
                        item: storagePost,
                        folderName: TextLiterals.allPostsScrapFolderText
                    )
                } else {
                    self?.realm.deletePost(url: storagePost.url ?? String())
                }
            })
            .disposed(by: disposeBag)
        
        tableViewReload
            .startWith(LoadingView.showLoading())
            .flatMapLatest( { [weak self] _ -> Observable<GetTagPostResponse> in
                guard let self = self else { return Observable.empty() }
                return self.getTagPosts()
            })
            .map { [weak self] response -> (GetTagPostResponse, [Bool]) in
                let posts = response.tagPostDtoList ?? []
                let storagePosts = posts.map { self?.convertTagPostDtoListToStoragePost(input: $0) }
                let isScrapList = storagePosts.map {
                    self?.checkIsUniquePost(post: $0 ?? StoragePost(img: "", name: "", summary: "", title: "", url: "")) ?? false
                }
                return (response, isScrapList)
            }
            .subscribe(onNext: { [weak self] postList, isScrapList in
                self?.isPostsEmptyOutput.accept(self?.checkStorageEmpty(input: postList) ?? false)
                self?.tagPostsListOutput.accept(postList)
                self?.tagPostsListDidScrapOutput.accept(isScrapList)
                LoadingView.hideLoading()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - func

    private func convertTagPostDtoListToStoragePost(
        input: TagPostDtoList
    ) -> StoragePost {
        return StoragePost(
            img: input.img ?? "",
            name: input.name ?? "",
            summary: input.summary ?? "",
            title: input.title ?? "",
            url: input.url ?? ""
        )
    }
    
    private func checkIsUniquePost(
        post: StoragePost
    ) -> Bool {
        return realm.checkUniquePost(input: post)
    }

    private func checkStorageEmpty(
        input: GetTagPostResponse
    ) -> Bool {
        if input.tagPostDtoList == nil { return true }
        else { return false }
    }
}

// MARK: - API

private extension KeywordsPostsViewModel {
    func getTagPosts() -> Observable<GetTagPostResponse> {
        return Observable.create { observer in
            NetworkService.shared.postsRepository.getTagPosts() { result in
                switch result {
                case .success(let response):
                    guard let posts = response as? GetTagPostResponse else {
                        observer.onError(NSError(domain: "ParsingError", code: 0, userInfo: nil))
                        return
                    }
                    observer.onNext(posts)
                    observer.onCompleted()
                case .requestErr(let errResponse):
                    observer.onError(errResponse as! Error)
                default:
                    observer.onError(NSError(domain: "UnknownError", code: 0, userInfo: nil))
                }
            }
            return Disposables.create()
        }
    }
}
