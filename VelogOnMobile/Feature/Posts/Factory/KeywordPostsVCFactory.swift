//
//  KeywordPostsVCFactory.swift
//  VelogOnMobile
//
//  Created by 장석우 on 2023/06/21.
//

import Foundation

final class KeywordPostsVCFactory {
    func create(
        tag: String,
        isNavigationBarHidden: Bool
    ) -> PostsViewController {
        let vc = PostsViewController(
            viewModel: PostsViewModel(viewType: .keyword, tag: tag),
            isNavigationBarHidden: isNavigationBarHidden
        )
        return vc
    }
}
