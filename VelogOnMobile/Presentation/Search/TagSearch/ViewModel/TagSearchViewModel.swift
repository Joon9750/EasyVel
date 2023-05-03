//
//  KeywordSearchViewModel.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/03.
//

import UIKit

protocol TagSearchViewModelInput {
    func tagAddButtonDidTap(tag: String)
}

protocol TagSearchViewModelOutput {
}

protocol TagSearchViewModelInputOutput: TagSearchViewModelInput, TagSearchViewModelOutput {}

final class TagSearchViewModel: TagSearchViewModelInputOutput {
    
    // MARK: - Input
    
    func tagAddButtonDidTap(tag: String) {
        addTag(tag: tag) { [weak self] response in
            guard self != nil else {
                return
            }
        }
    }
}

private extension TagSearchViewModel {
    func addTag(tag: String, completion: @escaping ([String]) -> Void) {
        NetworkService.shared.tagRepository.addTag(tag: tag) { result in
            switch result {
            case .success(let response):
                guard let list = response as? [String] else { return }
                completion(list)
            case .requestErr(let errResponse):
                dump(errResponse)
                // MARK: - 이미 있는 태그, 예외처리
            default:
                print("error")
            }
        }
    }
}
