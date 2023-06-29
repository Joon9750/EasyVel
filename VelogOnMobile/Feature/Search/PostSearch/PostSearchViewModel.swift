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
    
    // MARK: - Output
    
    var popularPostKeywordListOutput = PublishRelay<[String]>()
    var searchPostOutput = PublishRelay<[PostDTO]>()
    
    override init() {
        super.init()
        makeOutput()
    }
    
    private func makeOutput() {
        viewDidLoad
            .flatMapLatest { [weak self] _ -> Observable<[String]> in
                guard let self = self else { return Observable.empty() }
                return self.getPopularPostKeyword()
            }
            .subscribe(onNext: { [weak self] popularPostKeywordList in
                guard let self = self else { return }
                self.popularPostKeywordListOutput.accept(popularPostKeywordList)
            })
            .disposed(by: disposeBag)
    }
}

extension PostSearchViewModel {
    func getPopularPostKeyword() -> Observable<[String]> {
        return Observable.create { observer in
            NetworkService.shared.postsRepository.getPopularPosts() { [weak self] result in
                switch result {
                case .success(let response):
                    guard let result = response as? [String] else {
                        self?.serverFailOutput.accept(true)
                        observer.onCompleted()
                        return
                    }
                    observer.onNext(result)
                    observer.onCompleted()
                case .requestErr(_):
                    self?.serverFailOutput.accept(true)
                    observer.onCompleted()
                default:
                    self?.serverFailOutput.accept(true)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}