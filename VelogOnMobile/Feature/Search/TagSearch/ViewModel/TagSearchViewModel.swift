//
//  KeywordSearchViewModel.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/03.
//

import UIKit

import RxRelay
import RxSwift

final class TagSearchViewModel: BaseViewModel {
    
    var tagSearchDelegate: TagSearchProtocol?
    
    // MARK: - Input
    
    let tagAddButtonDidTap = PublishRelay<String>()

    // MARK: - Output
    
    var tagAddStatusOutput = PublishRelay<(Bool, String)>()
    
    override init() {
        super.init()
        makeOutput()
    }
    
    private func makeOutput() {
        viewWillDisappear
            .flatMapLatest { [weak self] _ -> Observable<[String]> in
                return self?.getTagList() ?? .empty()
            }
            .subscribe(onNext: { [weak self] list in
                self?.tagSearchDelegate?.searchTagViewWillDisappear(input: list.reversed())
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        tagAddButtonDidTap
            .flatMapLatest { [weak self] tag in
                return self?.addTag(tag: tag) ?? .empty()
            }
            .subscribe(onNext: { [weak self] success in
                if success {
                    let text: String = TextLiterals.addTagSuccessText
                    self?.tagAddStatusOutput.accept((success, text))
                } else {
                    let text: String = TextLiterals.addTagRequestErrText
                    self?.tagAddStatusOutput.accept((success, text))
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - api

private extension TagSearchViewModel {
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
        
    func getTagList() -> Observable<[String]> {
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
                case .requestErr(let errResponse):
                    self?.serverFailOutput.accept(true)
                    observer.onError(errResponse as! Error)
                default:
                    self?.serverFailOutput.accept(true)
                    observer.onError(NSError(domain: "UnknownError", code: 0, userInfo: nil))
                }
            }
            return Disposables.create()
        }
    }
}
