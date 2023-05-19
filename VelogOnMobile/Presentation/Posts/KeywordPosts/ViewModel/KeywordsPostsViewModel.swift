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
    
    var cellDidTap = PublishRelay<StoragePost>()
    var tableViewReload = PublishRelay<Void>()

    // MARK: - Output
    
    var tagPostsListOutput = PublishRelay<GetTagPostResponse>()
    var toastPresentOutput = PublishRelay<Bool>()
    var isPostsEmptyOutput = PublishRelay<Bool>()
    
    override init() {
        super.init()
        makeOutput()
    }
    
    private func makeOutput() {
        viewWillAppear
            .startWith(LoadingView.showLoading())
            .flatMapLatest( { [weak self] _ -> Observable<GetTagPostResponse> in
                guard let self = self else { return Observable.empty() }
                return self.getTagPosts()
            })
            .subscribe(onNext: { [weak self] postList in
                self?.isPostsEmptyOutput.accept(self?.checkStorageEmpty(input: postList) ?? false)
                self?.tagPostsListOutput.accept(postList)
                LoadingView.hideLoading()
            })
            .disposed(by: disposeBag)
        
        cellDidTap
            .filter { [weak self] response in
                if self?.checkIsUniquePost(post: response) == false {
                    self?.toastPresentOutput.accept(false)
                }
                return self?.checkIsUniquePost(post: response) ?? false
            }
            .subscribe(onNext: { [weak self] response in
                self?.addPostRealm(post: response)
                self?.toastPresentOutput.accept(true)
            })
            .disposed(by: disposeBag)
        
        tableViewReload
            .startWith(LoadingView.showLoading())
            .flatMapLatest( { [weak self] _ -> Observable<GetTagPostResponse> in
                guard let self = self else { return Observable.empty() }
                return self.getTagPosts()
            })
            .subscribe(onNext: { [weak self] postList in
                self?.isPostsEmptyOutput.accept(self?.checkStorageEmpty(input: postList) ?? false)
                self?.tagPostsListOutput.accept(postList)
                LoadingView.hideLoading()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - func

    private func addPostRealm(post: StoragePost) {
        realm.addPost(item: post)
    }

    private func checkIsUniquePost(post: StoragePost) -> Bool {
        return realm.checkUniquePost(input: post)
    }

    private func checkStorageEmpty(input: GetTagPostResponse) -> Bool {
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
