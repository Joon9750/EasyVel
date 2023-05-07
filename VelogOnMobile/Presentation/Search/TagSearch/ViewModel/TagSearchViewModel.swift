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
    var tagAddStatus: ((Bool, String) -> Void)? { get set }
}

protocol TagSearchViewModelInputOutput: TagSearchViewModelInput, TagSearchViewModelOutput {}

final class TagSearchViewModel: TagSearchViewModelInputOutput {

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
}
