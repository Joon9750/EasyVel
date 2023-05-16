//
//  KeywordSearchViewModel.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/03.
//

import UIKit

import RxRelay
import RxSwift

protocol TagSearchViewModelInput {
    func tagAddButtonDidTap(tag: String)
    func viewWillDisappear()
}

protocol TagSearchViewModelOutput {
    var tagAddStatus: ((Bool, String) -> Void)? { get set }
}

protocol TagSearchViewModelInputOutput: TagSearchViewModelInput, TagSearchViewModelOutput {}

final class TagSearchViewModel: BaseViewModel {
    
    var tagSearchDelegate: TagSearchProtocol?

//    var tagList: [String]? {
//        didSet {
//            if let tagList = tagList {
//                tagSearchDelegate?.searchTagViewWillDisappear(input: tagList)
//            }
//        }
//    }
    
    // MARK: - Output
    
    var tagAddStatusOutput = PublishRelay<(Bool, String)>()
    
    var tagAddStatus: ((Bool, String) -> Void)?
    
    // MARK: - Input
    
    let tagAddButtonDidTap = PublishRelay<String>()
    
    func tagAddButtonDidTap(tag: String) {
        addTag(tag: tag) { [weak self] response in
            guard self != nil else {
                return
            }
        }
    }
    
    override init() {
        super.init()
        makeOutput()
    }
    
    private func makeOutput() {
        viewWillDisappear
            .subscribe(onNext: { [weak self] _ in
                self?.getTagList()
            })
            .disposed(by: disposeBag)
    }
}

private extension TagSearchViewModel {
    func addTag(tag: String, completion: @escaping (String) -> Void) {
        NetworkService.shared.tagRepository.addTag(tag: tag) { [weak self] result in
            switch result {
            case .success(_):
                let text: String = TextLiterals.addTagSuccessText
                if let tagAddStatus = self?.tagAddStatus {
                    tagAddStatus(true, text)
                }
                completion("success")
            case .requestErr(let errResponse):
                let text: String = TextLiterals.addTagRequestErrText
                if let tagAddStatus = self?.tagAddStatus {
                    tagAddStatus(false, text)
                }
                dump(errResponse)
            default:
                print("error")
            }
        }
    }

    func getTagList() -> Observable<[String]> {
        return Observable.create { observer -> Disposable in
            NetworkService.shared.tagRepository.getTag() { result in
                switch result {
                case .success(let response):
                    guard let list = response as? [String] else { return }
                    self.tagSearchDelegate?.searchTagViewWillDisappear(input: list)
                    observer.onNext(list)
                    observer.onCompleted()
                case .requestErr(let errResponse):
                    dump(errResponse)
                default:
                    print("error")
                }
            }
            return Disposables.create()
        }
    }
}
