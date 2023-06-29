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

final class PostsViewModel: BaseViewModel {
    
    enum ViewType {
        case trend
        case follow
        case keyword
    }
    
    let realm = RealmService()
    
    private var viewType: ViewType = .trend
    private var tag: String

    // MARK: - Input
    
    var cellScrapButtonDidTap = PublishRelay<(StoragePost, Bool)>()
    var tableViewReload = PublishRelay<Void>()

    // MARK: - Output
    
    var postsListOutput = PublishRelay<[PostDTO]>()
    var isPostsEmptyOutput = PublishRelay<Bool>()
    var postsListDidScrapOutput = PublishRelay<[Bool]>()
    
    init(
        viewType: ViewType,
         tag: String = ""
    ) {
        self.viewType = viewType
        self.tag = tag
        super.init()
        
        makeOutput()
    }
    
    private func makeOutput() {
        viewWillAppear
            .startWith(LoadingView.showLoading())
            .flatMapLatest( { _ -> Observable<[PostDTO]?> in
                //MARK: - fix me  Rx와 참조 관련 공부 후 리팩
                //guard let self = self else { return Observable.empty() }
                
                switch self.viewType {
                case .trend:
                    return self.getTrendPosts()
                case .follow:
                    return self.getSubscriberPosts()
                case .keyword:
                    return self.getOneTagPosts(tag: self.tag)
                }
                
            })
            .map { [weak self] dto -> ([PostDTO], [Bool]) in
                let posts = dto ?? []
                let storagePosts = posts.map { self?.convertPostDtoToStoragePost(input: $0) }
                let isScrapList = storagePosts.map {
                    self?.checkIsUniquePost(post: $0 ?? StoragePost(img: "", name: "", summary: "", title: "", url: "")) ?? false
                }
                return (posts, isScrapList)
            }
            .subscribe(onNext: { [weak self] postList, isScrapList in
                self?.isPostsEmptyOutput.accept(postList.isEmpty)
                self?.postsListOutput.accept(postList)
                self?.postsListDidScrapOutput.accept(isScrapList)
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
            .flatMapLatest( { [weak self] _  -> Observable<[PostDTO]?> in
                guard let self = self else { return Observable.empty() }
                switch self.viewType {
                case .trend:
                    return self.getTrendPosts()
                case .follow:
                    return self.getSubscriberPosts()
                case .keyword:
                    return self.getOneTagPosts(tag: self.tag)
                }
            })
            .map { [weak self] dto -> ([PostDTO], [Bool]) in
                let posts = dto ?? []
                let storagePosts = posts.map { self?.convertPostDtoToStoragePost(input: $0) }
                let isScrapList = storagePosts.map {
                    self?.checkIsUniquePost(post: $0 ?? StoragePost(img: "", name: "", summary: "", title: "", url: "")) ?? false
                }
                return (posts, isScrapList)
            }
            .subscribe(onNext: { [weak self] postList, isScrapList in
                self?.isPostsEmptyOutput.accept(postList.isEmpty)
                self?.postsListOutput.accept(postList)
                self?.postsListDidScrapOutput.accept(isScrapList)
                LoadingView.hideLoading()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - func

    private func convertPostDtoToStoragePost(
        input: PostDTO
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
}

// MARK: - API

private extension PostsViewModel {
    func getOneTagPosts(tag: String) -> Observable<[PostDTO]?> {
        return Observable.create { observer in
            NetworkService.shared.postsRepository.getOneTagPosts(tag: tag) { [weak self] result in
                switch result {
                case .success(let response):
                    guard let posts = response as? [PostDTO] else {
                        self?.serverFailOutput.accept(true)
                        observer.onError(NSError(domain: "ParsingError", code: 0, userInfo: nil))
                        return
                    }
                    observer.onNext(posts)
                    observer.onCompleted()
                case .requestErr(_):
                    self?.serverFailOutput.accept(true)
                    observer.onError(NSError(domain: "requestErr", code: 0, userInfo: nil))
                default:
                    self?.serverFailOutput.accept(true)
                    observer.onError(NSError(domain: "UnknownError", code: 0, userInfo: nil))
                }
            }
            return Disposables.create()
        }
    }
    
    func getTrendPosts() -> Observable<[PostDTO]?> {
        return Observable.create { observer in
            NetworkService.shared.postsRepository.getTrendPosts() { [weak self] result in
                switch result {
                case .success(let response):
                    guard let posts = response as? TrendPostResponse else {
                        self?.serverFailOutput.accept(true)
                        observer.onError(NSError(domain: "ParsingError", code: 0, userInfo: nil))
                        return
                    }
                    observer.onNext(posts.trendPostDtos)
                    observer.onCompleted()
                case .requestErr(_):
                    self?.serverFailOutput.accept(true)
                    observer.onError(NSError(domain: "requestErr", code: 0, userInfo: nil))
                default:
                    self?.serverFailOutput.accept(true)
                    observer.onError(NSError(domain: "UnknownError", code: 0, userInfo: nil))
                }
            }
            return Disposables.create()
        }
    }
    
    func getSubscriberPosts() -> Observable<[PostDTO]?> {
        return Observable.create { observer in
            NetworkService.shared.postsRepository.getSubscriberPosts() { [weak self] result in
                switch result {
                case .success(let response):
                    guard let posts = response as? GetSubscriberPostResponse else {
                        self?.serverFailOutput.accept(true)
                        observer.onError(NSError(domain: "ParsingError", code: 0, userInfo: nil))
                        return
                    }
                    observer.onNext(posts.subscribePostDtoList)
                    observer.onCompleted()
                case .requestErr(_):
                    self?.serverFailOutput.accept(true)
                    observer.onError(NSError(domain: "requestErr", code: 0, userInfo: nil))
                default:
                    self?.serverFailOutput.accept(true)
                    observer.onError(NSError(domain: "UnknownError", code: 0, userInfo: nil))
                }
            }
            return Disposables.create()
        }
    }
}
