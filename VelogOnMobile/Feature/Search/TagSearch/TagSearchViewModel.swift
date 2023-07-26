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
    
    private var addTag: String?
    private var deleteTag: String?
    private var myTagDidChange: Bool = false
    
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
    
    struct Input {
        var searchBarDidEditEvent: Observable<String>
        var searchTextFieldDidEnd: Observable<Void>
        var myTagCellDidTap: Observable<String>
    }

    // MARK: - Output
    
    var myTagsOutput = PublishRelay<[String]>()
    var popularTagsOutput = BehaviorRelay<[String]>(value: Array<String>(repeating: "", count: 10))
    
    var presentDeleteMyTagAlertOutput = PublishRelay<Bool>()
    
    var tagAddStatusOutput = PublishRelay<(Bool, String)>()
    var deleteTagStatusOutPut = PublishRelay<(Bool, String)>()
    var myTagsEmpty = PublishRelay<Bool>()
    
    override init() {
        super.init()
        
    }
    
    func transform(_ input: Input) {
        
        viewWillAppear
            .subscribe { [weak self] _ in
                self?.getMyTags()
                self?.popularTagsOutput.accept(self?.popularTagList ?? [String]())
            }
            .disposed(by: disposeBag)
        
        input.searchBarDidEditEvent
            .subscribe { [weak self] tag in
                self?.addTag = tag
            }
            .disposed(by: disposeBag)
        
        input.searchTextFieldDidEnd
            .subscribe(onNext: { [weak self] _ in
                guard let tag = self?.addTag else { return }
                guard let self else { return }
                guard tag.isValidText else { return }
                self.requestAddTagAPI(tag: tag)
                    .subscribe(onNext: { [weak self] success in
                        if success {
                            let text: String = TextLiterals.addTagSuccessText
                            self?.tagAddStatusOutput.accept((success, text))
                            self?.getMyTags()
                            self?.myTagDidChange = true
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
                self?.deleteTag = tag
                self?.presentDeleteMyTagAlertOutput.accept(true)
            }
            .disposed(by: disposeBag)
        
        viewWillDisappear
            .subscribe{[weak self] _ in
                guard let self else { return }
                if self.myTagDidChange {
                    NotificationCenter.default.post(
                        name: Notification.Name("updateHomeVC"),
                        object: nil
                    )
                }
            }
            .disposed(by: disposeBag)
            
    }
    
    func myTagDeleteEvent() {
        guard let tag = self.deleteTag else { return }
        self.requestDeleteTagAPI(tag: tag)
            .subscribe(onNext: { [weak self] success in
                if success {
                    let text: String = TextLiterals.deleteTagSuccess
                    self?.tagAddStatusOutput.accept((success, text))
                    self?.getMyTags()
                    self?.myTagDidChange = true
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
        requestMyTagAPI()
            .subscribe(onNext: { [weak self] myTags in
                self?.myTagsEmpty.accept(myTags.isEmpty)
                self?.myTagsOutput.accept(myTags)
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    func requestAddTagAPI(tag: String) -> Observable<Bool> {
        return Observable.create { observer in
            NetworkService.shared.tagRepository.addTag(tag: tag) { [weak self] result in
                switch result {
                case .success(_):
                    observer.onNext(true)
                    observer.onCompleted()
                case .requestErr(_):
                    // MARK: - 이미 추가된 관심태그 예외
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
