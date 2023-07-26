//
//  PostSearchViewModel.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/06/29.
//

import UIKit

import RxRelay
import RxSwift

final class PostSearchViewModel: BaseViewModel {
    
    private let realm = RealmService()
    
    private let popularTagList: [String] = [
        "알고리즘",
        "JavaScript",
        "TIL",
        "Java",
        "React",
        "백준",
        "python",
        "프로그래머스",
        "코딩테스트",
        "Spring"
    ]
    
    // MARK: - Input
    
    let searchPostTagInput = PublishRelay<String>()
    let addCurrentSearchTagInput = PublishRelay<String>()
    let deleteAllCurrentSearchTagInput = PublishRelay<Void>()
    
    // MARK: - Output
    
    var popularPostKeywordListOutput = PublishRelay<[String]>()
    var searchPostOutput = PublishRelay<[PostDTO]>()
    var currentSearchTagListOutput = PublishRelay<[String]>()
    
    override init() {
        super.init()
        makeOutput()
    }
    
    private func makeOutput() {
        viewWillAppear
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.popularPostKeywordListOutput.accept(self.popularTagList)
                
                let currentSearchTagList = self.getCurrentSearchTags()
                self.currentSearchTagListOutput.accept(currentSearchTagList)
            })
            .disposed(by: disposeBag)
        
        searchPostTagInput
            .flatMap { [weak self] searchTag -> Observable<[PostDTO]> in
                LoadingView.showLoading()
                guard let self = self else {
                    LoadingView.hideLoading()
                    return Observable.empty()
                }
                guard searchTag.isValidText else {
                    LoadingView.hideLoading()
                    return Observable.empty()
                }
                return self.getOneTagPosts(tag: searchTag)
            }
            .subscribe(onNext: { [weak self] postDto in
                guard let self = self else {
                    LoadingView.hideLoading()
                    return
                }
                LoadingView.hideLoading()
                self.searchPostOutput.accept(postDto)
            })
            .disposed(by: disposeBag)
        
        addCurrentSearchTagInput
            .subscribe(onNext: { [weak self] searchedTag in
                guard let self = self else { return }
                guard searchedTag.isValidText else { return }
                self.realm.addCurrentSearchTag(tag: searchedTag)
                
                let currentSearchTagList = self.getCurrentSearchTags()
                self.currentSearchTagListOutput.accept(currentSearchTagList)
            })
            .disposed(by: disposeBag)
        
        deleteAllCurrentSearchTagInput
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.realm.deleteAllRealmData()
                
                let afterDeleteCurrentSearchTags = self.getCurrentSearchTags()
                self.currentSearchTagListOutput.accept(afterDeleteCurrentSearchTags)
            })
            .disposed(by: disposeBag)
    }
    
    private func getCurrentSearchTags() -> [String] {
        let currentSearchTagList = realm.getCurrentSearchTags()
        return currentSearchTagList.reversed()
    }
}

extension PostSearchViewModel {
    func getOneTagPosts(tag: String) -> Observable<[PostDTO]> {
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
                    // MARK: - 202, 불러올 포스트가 없을 때 들어옴
                    self?.searchPostOutput.accept([PostDTO]())
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
