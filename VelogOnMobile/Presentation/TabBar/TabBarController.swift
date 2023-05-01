//
//  TabBarController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//

import UIKit

import SnapKit

final class TabBarController: UITabBarController {
    
    fileprivate lazy var defaultTabBarHeight = { tabBar.frame.size.height }()
    
    let listViewModel = ListViewModel()
    let PostsVC = PostsTabManViewController()
    lazy var ListVC = ListViewController(viewModel: listViewModel)
    let notifiVC = NotificationViewController()
    let settingVC = SettingViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        setUpTabBar()
    }
    
    func setUpTabBar(){
        self.tabBar.tintColor = .brandColor
        self.tabBar.unselectedItemTintColor = .black
        self.tabBar.isTranslucent = false
        self.tabBar.backgroundColor = .white

        PostsVC.title = "Posts"
        ListVC.title = "Lists"
        notifiVC.title = "Alerm"
        settingVC.title = "Setting"

        let ViewControllers:[UIViewController] = [PostsVC,ListVC,notifiVC,settingVC]
        self.setViewControllers(ViewControllers, animated: true)

        PostsVC.tabBarItem.image = UIImage(systemName: "books.vertical")
        ListVC.tabBarItem.image = UIImage(systemName: "folder")
        notifiVC.tabBarItem.image = UIImage(systemName: "bell")
        settingVC.tabBarItem.image = UIImage(systemName: "gearshape")
        
        self.hidesBottomBarWhenPushed = false
        viewWillLayoutSubviews()
    }
}
