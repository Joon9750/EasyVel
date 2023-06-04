//
//  PostsViewModel.swift
//  VelogOnMobile
//
//  Created by 장석우 on 2023/06/03.
//

import Foundation

import RxSwift
import RxCocoa

final class PostsViewModel {
    
    //MARK: - Input
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let scrollReachedBottomEvent: Observable<Void>
        let postCellDidTapEvent: Observable<Int>
        let scrapButtonDidTapEvent: Observable<Int>
    }
    
    //MARK: - Output
    
    struct Output {
        var posts = BehaviorRelay<[TagPostDtoList]>(value: [])
        var post = PublishRelay<WebViewModel>()
    }
    
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewWillAppearEvent
            .subscribe(onNext: { [weak self] in
                self?.requestTagPostsAPI()
                    .bind(to: output.posts)
                    .disposed(by: disposeBag)
            })
            .disposed(by: disposeBag)
        
        input.postCellDidTapEvent
            .subscribe(onNext: { index in
                let url = output.posts.value[index].url
                guard let url else { return }
                output.post.accept(WebViewModel(url: url))
            })
            .disposed(by: disposeBag)
        
        
        input.scrapButtonDidTapEvent
            .subscribe(onNext: { [weak self] index in
                print("Not Yet")
            })
            .disposed(by: disposeBag)
        
        input.scrollReachedBottomEvent
            .subscribe(onNext: { [weak self] in
                print("Not Yet")
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
}

private extension PostsViewModel {
    func requestTagPostsAPI() -> Observable<[TagPostDtoList]>{
        return Observable.create { observer in
            NetworkService.shared.postsRepository.getTagPosts() { result in
                switch result {
                case .success(let response):
                    guard let response = response as? GetTagPostResponse else {
                        observer.onError(NSError(domain: "ParsingError", code: 0, userInfo: nil))
                        return
                    }
                    observer.onNext(response.tagPostDtoList ?? [])
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
