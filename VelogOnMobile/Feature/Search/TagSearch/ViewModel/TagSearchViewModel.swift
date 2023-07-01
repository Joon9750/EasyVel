//
//  KeywordSearchViewModel.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/03.
//

import UIKit

import RxRelay
import RxCocoa
import RxSwift

final class TagSearchViewModel: BaseViewModel {
    
    //MARK: - Properties
    
    var tagSearchDelegate: TagSearchProtocol?
    var tag: String?
    
    // MARK: - Input
    
    struct Input {
        var searchBarDidEditEvent: Observable<String>
        var searchTextFieldDidEnd: Observable<Void>
        var myTagCellDidTap: Observable<String>
    }

    // MARK: - Output
    
    var myTagsOutput = PublishRelay<[String]>()
    var popularTagsOutput = BehaviorRelay<[String]>(value: Array<String>(repeating: "", count: 10))
    var tableViewReload = PublishRelay<Bool>()
    
    var deleteMyTagAlertPresentOutput = PublishRelay<String>()
    
    var tagAddStatusOutput = PublishRelay<(Bool, String)>()
    var deleteTagStatusOutPut = PublishRelay<(Bool, String)>()
    
    override init() {
        super.init()
        
    }
    
    func transform(_ input: Input) {
        
        viewWillAppear
            .subscribe { [weak self] _ in
                self?.getPopularTags()
                self?.getMyTags()
            }
            .disposed(by: disposeBag)
        
        input.searchBarDidEditEvent
            .subscribe { [weak self] tag in
                self?.tag = tag
            }
            .disposed(by: disposeBag)
        
        input.searchTextFieldDidEnd
            .subscribe(onNext: { [weak self] _ in
                guard let tag = self?.tag else { return }
                guard let self else { return }
                
                self.addTag(tag: tag)
                    .subscribe(onNext: { [weak self] success in
                        if success {
                            let text: String = TextLiterals.addTagSuccessText
                            self?.tagAddStatusOutput.accept((success, text))
                            self?.getMyTags()
                            NotificationCenter.default.post(
                                name: Notification.Name("updateHomeVC"),
                                object: nil
                            )
                        } else {
                            let text: String = TextLiterals.addTagRequestErrText
                            self?.tagAddStatusOutput.accept((success, text))
                        }
                    })
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        
        input.myTagCellDidTap
            .subscribe { [weak self] tag in
                self?.deleteMyTagAlertPresentOutput.accept(tag)
            }
            .disposed(by: disposeBag)
        
            
    }
    
    func myTagDeleteEvent(tag: String) {
        self.requestDeleteTagAPI(tag: tag)
            .subscribe(onNext: { [weak self] success in
                if success {
                    let text: String = TextLiterals.deleteTagSuccess
                    self?.tagAddStatusOutput.accept((success, text))
                    self?.getMyTags()
                    NotificationCenter.default.post(
                        name: Notification.Name("updateHomeVC"),
                        object: nil
                    )
                } else {
                    let text: String = TextLiterals.unknownError
                    self?.tagAddStatusOutput.accept((success, text))
                }
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: - api

private extension TagSearchViewModel {
    
    func getMyTags() {
        requestMyTagAPI().bind(to: self.myTagsOutput)
            .disposed(by: self.disposeBag)
    }
    
    func getPopularTags() {
        requestPopularTagsAPI().bind(to: self.popularTagsOutput)
            .disposed(by: self.disposeBag)
    }
    
    
    func addTag(tag: String) -> Observable<Bool> {
        return Observable.create { observer in
            NetworkService.shared.tagRepository.addTag(tag: tag) { [weak self] result in
                switch result {
                case .success(_):
                    observer.onNext(true)
                    observer.onCompleted()
                case .requestErr(_):
                    self?.serverFailOutput.accept(true)
                    observer.onNext(false)
                    observer.onCompleted()
                default:
                    self?.serverFailOutput.accept(true)
                    observer.onError(NSError(domain: "UnknownError", code: 0, userInfo: nil))
                }
            }
            return Disposables.create()
        }
    }
        
    func requestMyTagAPI() -> Observable<[String]> {
        return Observable.create { observer in
            NetworkService.shared.tagRepository.getTag() { [weak self] result in
                switch result {
                case .success(let response):
                    guard let list = response as? [String] else {
                        self?.serverFailOutput.accept(true)
                        observer.onError(NSError(domain: "ParsingError", code: 0, userInfo: nil))
                        return
                    }
                    observer.onNext(list)
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
    
    func requestPopularTagsAPI() -> Observable<[String]> {
        return Observable.create { observer in
            NetworkService.shared.postsRepository.getPopularPosts { [weak self] result in
                switch result {
                case .success(let response):
                    guard let list = response as? [String] else {
                        self?.serverFailOutput.accept(true)
                        observer.onError(NSError(domain: "ParsingError", code: 0, userInfo: nil))
                        return
                    }
                    print(list)
                    observer.onNext(list)
                    observer.onCompleted()
                    self?.tableViewReload.accept(true)
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
    
    func requestDeleteTagAPI(tag: String) -> Observable<Bool> {
        return Observable.create { observer in
            NetworkService.shared.tagRepository.deleteTag(tag: tag) { [weak self] result in
                switch result {
                case .success(_):
                    observer.onNext(true)
                    observer.onCompleted()
                case .requestErr(_):
                    self?.serverFailOutput.accept(true)
                    observer.onNext(false)
                    observer.onCompleted()
                default:
                    self?.serverFailOutput.accept(true)
                    observer.onError(NSError(domain: "UnknownError", code: 0, userInfo: nil))
                }
            }
            return Disposables.create()
        }
    }
    
    
}
