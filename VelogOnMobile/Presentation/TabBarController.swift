//
//  TabBarController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//

import UIKit

import SnapKit
import Moya


class TabBarController: UITabBarController{
    
    fileprivate lazy var defaultTabBarHeight = { tabBar.frame.size.height }()
    
    let KeyWordVC = KeyWordPostsViewController()
    let subScribeVC = SubscribeTabManViewController()
    let notifiVC = NotificationViewController()
    let myPageVC = MyPageViewController()
    
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

        KeyWordVC.title = "Keyword"
        subScribeVC.title = "Subscribe"
        notifiVC.title = "Notification"
        myPageVC.title = "My Page"

        let ViewControllers:[UIViewController] = [KeyWordVC,subScribeVC,notifiVC,myPageVC]
        self.setViewControllers(ViewControllers, animated: true)

        KeyWordVC.tabBarItem.image = UIImage(systemName: "text.book.closed")
        subScribeVC.tabBarItem.image = UIImage(systemName: "person.2")
        notifiVC.tabBarItem.image = UIImage(systemName: "megaphone")
        myPageVC.tabBarItem.image = UIImage(systemName: "person.crop.square")
        
        self.hidesBottomBarWhenPushed = false
        viewWillLayoutSubviews()
    }
}

