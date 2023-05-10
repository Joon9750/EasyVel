//
//  KeywordSearchViewModel.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/03.
//

import UIKit

protocol TagSearchViewModelInput {
    func tagAddButtonDidTap(tag: String)
    func viewWillDisappear()
}

protocol TagSearchViewModelOutput {
    var tagAddStatus: ((Bool, String) -> Void)? { get set }
}

protocol TagSearchViewModelInputOutput: TagSearchViewModelInput, TagSearchViewModelOutput {}

final class TagSearchViewModel: TagSearchViewModelInputOutput {
    
    var tagSearchDelegate: TagSearchProtocol?

    var tagList: [String]? {
        didSet {
            if let tagList = tagList {
                tagSearchDelegate?.searchTagViewWillDisappear(input: tagList)
            }
        }
    }
    
    // MARK: - Output
    
    var tagAddStatus: ((Bool, String) -> Void)?
    
    // MARK: - Input
    
    func tagAddButtonDidTap(tag: String) {
        addTag(tag: tag) { [weak self] response in
            guard self != nil else {
                return
            }
        }
    }
    
    func viewWillDisappear() {
        getTagListForServer()
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
    
    func getTagListForServer() {
        self.getTagList() { [weak self] response in
            guard let self = self else {
                return
            }
            self.tagList = Array(response.reversed())
        }
    }
    
    func getTagList(completion: @escaping ([String]) -> Void) {
        NetworkService.shared.tagRepository.getTag() { result in
            switch result {
            case .success(let response):
                guard let list = response as? [String] else { return }
                completion(list)
            case .requestErr(let errResponse):
                dump(errResponse)
            default:
                print("error")
            }
        }
    }
}
