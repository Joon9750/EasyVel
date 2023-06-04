//
//  KeywordViewControllerFactory.swift
//  VelogOnMobile
//
//  Created by 장석우 on 2023/06/02.
//

import UIKit

final class PostViewControllerFactory: ViewControllerCreator {
    
    func createViewController() -> UIViewController {
        return KeywordsPostsViewController(viewModel: KeywordsPostsViewModel())
    }
}
