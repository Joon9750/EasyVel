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
    
    var tagSearchDelegate: TagSearchProtocol?
    
    // MARK: - Input
    
    let tagAddButtonDidTap = PublishRelay<String>()

    // MARK: - Output
    
    var myTagsOutput = PublishRelay<[String]>()
    var popularTagsOutput = BehaviorRelay<[String]>(value: Array<String>(repeating: "", count: 10))
    var tableViewReload = PublishRelay<Bool>()
    var tagAddStatusOutput = PublishSubject<(Bool, String)>()
    
    override init() {
        super.init()
        makeOutput()
    }
    
    private func makeOutput() {
        viewWillAppear
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                self.getPopularTags()
                self.getMyTags()
            }
            .disposed(by: disposeBag)
        
        
//        viewWillDisappear
//            .flatMapLatest { [weak self] _ -> Observable<[String]> in
//                return self?.getTagList() ?? .empty()
//            }
//            .subscribe(onNext: { [weak self] list in
//                self?.tagSearchDelegate?.searchTagViewWillDisappear(input: list.reversed())
//            }, onError: { error in
//                print(error)
//            })
//            .disposed(by: disposeBag)
//
//        tagAddButtonDidTap
//            .flatMapLatest { [weak self] tag in
//                return self?.addTag(tag: tag) ?? .empty()
//            }
//            .subscribe(onNext: { [weak self] success in
//                if success {
//                    let text: String = TextLiterals.addTagSuccessText
//                    self?.tagAddStatusOutput.accept((success, text))
//                } else {
//                    let text: String = TextLiterals.addTagRequestErrText
//                    self?.tagAddStatusOutput.accept((success, text))
//                }
//            })
//            .disposed(by: disposeBag)
    }
}

// MARK: - api

private extension TagSearchViewModel {
    
    func getMyTagDummy() {
        let dummy: Observable<[String]> = Observable.just(["나의",
                                                           "더덤덤덤덤더",
                                                           "태그",
                                                           "나의",
                                                           "더더더더미미ㅣ미",
                                                           "태그"])
                                
        dummy.bind(to: self.myTagsOutput)
            .disposed(by: self.disposeBag)
    }
    
    func getMyTags() {
        requestMyTagAPI().bind(to: self.myTagsOutput)
            .disposed(by: self.disposeBag)
    }
    
    func getPopularTags() {
        requestPopularTagsAPI()
            .subscribe(onNext: { tags in
                self.popularTagsOutput.accept(tags)
            })
            .disposed(by: self.disposeBag)
            
    }
    
    func getPopularTagDummy() {
        let dummy: Observable<[String]> = Observable.just(["매우",
                                                           "인기있는",
                                                           "태그들",
                                                           "매우",
                                                           "인기있는",
                                                           "태그들",
                                                           "매우",
                                                           "인기있는",
                                                           "태그들",
                                                           "마지막"])
                                
        dummy.bind(to: self.popularTagsOutput)
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
    
    
}
