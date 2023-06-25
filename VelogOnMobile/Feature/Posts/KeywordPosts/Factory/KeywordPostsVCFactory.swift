//
//  KeywordPostsVCFactory.swift
//  VelogOnMobile
//
//  Created by 장석우 on 2023/06/21.
//

import Foundation

final class KeywordPostsVCFactory {
    func create(tag: String) -> KeywordsPostsViewController {
        let vc = KeywordsPostsViewController(viewModel: KeywordsPostsViewModel())
        return vc
    }
}
