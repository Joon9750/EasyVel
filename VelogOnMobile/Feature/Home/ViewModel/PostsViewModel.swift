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
//        var ableWifi = PublishRelay<Bool>()
//        var isPostsEmpty = PublishRelay<Bool>()
        
        var posts = BehaviorRelay<[TagPostDtoList]>(value: [])
        var post = BehaviorRelay<WebViewModel>(value: .init(url: ""))
        
        
    }
    
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        self.bindOutput(output: output, disposeBag: disposeBag)
        
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
                print("scrapButtonDidTapEvent")
            })
            .disposed(by: disposeBag)
        
        input.scrollReachedBottomEvent
            .subscribe(onNext: { [weak self] in
                print("scrollReachedBottomEvent")
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    func bindOutput(output: Output, disposeBag: DisposeBag) {
        
    }

    
    //MARK: - Properties
    
//    var posts: [TagPostDtoList] = []
//    var post: WebViewModel = WebViewModel(url: "")
    
    //MARK: - Output
    
//    var ableWifi = Observable<Bool>.just(true)
//    var isPostsEmpty = Observable<Bool>.just(true)
//
//    var posts = BehaviorRelay<[TagPostDtoList]>(value: [])
//    var post = BehaviorRelay<WebViewModel>(value: .init(url: ""))

    //MARK: - Init
    
    
}

//MARK: - Input, View

extension PostsViewModel {
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
