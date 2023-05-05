//
//  TabBarController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//

import UIKit

import SnapKit

final class TabBarController: UITabBarController {
    
//    let realm = RealmService()
    
    fileprivate lazy var defaultTabBarHeight = { tabBar.frame.size.height }()
    
    let listViewModel = ListViewModel()
    let PostsVC = PostsTabManViewController()
    lazy var ListVC = ListViewController(viewModel: listViewModel)
    let storageVC = StorageViewController(viewModel: StorageViewModel())
    let settingVC = SettingViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        setUpTabBar()
        
//        realm.resetDB()
    }
    
    func setUpTabBar(){
        self.tabBar.tintColor = .brandColor
        self.tabBar.unselectedItemTintColor = .black
        self.tabBar.isTranslucent = false
        self.tabBar.backgroundColor = .white

        PostsVC.title = "Posts"
        ListVC.title = "Lists"
        storageVC.title = "Storage"
        settingVC.title = "Setting"

        let ViewControllers:[UIViewController] = [PostsVC,ListVC,storageVC,settingVC]
        self.setViewControllers(ViewControllers, animated: true)

        PostsVC.tabBarItem.image = UIImage(systemName: "books.vertical")
        ListVC.tabBarItem.image = UIImage(systemName: "list.bullet.rectangle.portrait")
        storageVC.tabBarItem.image = UIImage(systemName: "archivebox")
        settingVC.tabBarItem.image = UIImage(systemName: "gearshape")
        
        self.hidesBottomBarWhenPushed = false
        viewWillLayoutSubviews()
    }
}
