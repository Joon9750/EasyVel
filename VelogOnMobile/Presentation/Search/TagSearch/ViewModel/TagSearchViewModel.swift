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
        addTag(tag: tag)
    }
}

private extension TagSearchViewModel {
    func addTag(tag: String) {
        NetworkService.shared.tagRepository.addTag(tag: tag)
    }
}
