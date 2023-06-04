//
//  PostsViewModel.swift
//  VelogOnMobile
//
//  Created by 장석우 on 2023/06/03.
//

import Foundation

import RxSwift
import RxCocoa

protocol PostsViewModelInput {
    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
    
    func didSelectItemEvent(at indexPath: IndexPath)
    func scrapButtonDidTapEvent(at indexPath: IndexPath)
    func scrollReachedBottomEvent(at page: Int)
}

protocol PostsViewModelOutput {
    var posts: BehaviorRelay<[TagPostDtoList]> { get }
    var post: BehaviorRelay<WebViewModel> { get }
    
    var ableWifi: Observable<Bool> { get }
    var isPostsEmpty: Observable<Bool> { get }
}

protocol PostsViewModel: PostsViewModelInput, PostsViewModelOutput { }

final class DefaultPostsViewModel: PostsViewModel {
    
    //MARK: - Properties
    
//    var posts: [TagPostDtoList] = []
//    var post: WebViewModel = WebViewModel(url: "")
    
    //MARK: - Output
    
    var ableWifi = Observable<Bool>.just(true)
    var isPostsEmpty = Observable<Bool>.just(true)
    
    var posts = BehaviorRelay<[TagPostDtoList]>(value: [])
    var post = BehaviorRelay<WebViewModel>(value: .init(url: ""))

    //MARK: - Init
    
    
}

//MARK: - Input, View

extension DefaultPostsViewModel {
    
    func viewDidLoad() {
        print(#function)
    }
    
    func viewWillAppear() {
        print(#function)
    }
    
    func viewDidAppear() {
        print(#function)
    }
    
    func didSelectItemEvent(at indexPath: IndexPath) {
        print(#function)
    }
    
    func scrapButtonDidTapEvent(at indexPath: IndexPath) {
        print(#function)
    }
    
    func scrollReachedBottomEvent(at page: Int) {
        print(#function)
    }
}

private extension DefaultPostsViewModel {
    func requestTagPostsAPI() {
        NetworkService.shared.postsRepository.getTagPosts { result in
            switch result {
            case .success(let response):
                guard let response = response as? GetTagPostResponse else {
                    // observer.onError(NSError(domain: "ParsingError", code: 0, userInfo: nil))
                    return
                }
                posts.bind(to: response.tagPostDtoList)
                    .disposed(by: <#T##DisposeBag#>)
                observer.onNext(posts)
                observer.onCompleted()
            case .requestErr(let errResponse):
                observer.onError(errResponse as! Error)
            default:
                observer.onError(NSError(domain: "UnknownError", code: 0, userInfo: nil))
            }
        }
    }
}
