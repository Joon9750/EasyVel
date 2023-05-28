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

    // MARK: - viewModel properties
    
    let listViewModel = ListViewModel()
    let scrapStorageViewModel = ScrapStorageViewModel()
    
    // MARK: - viewController properties
    
    let PostsVC = PostsTabManViewController()
    lazy var ListVC = ListViewController(viewModel: listViewModel)
    lazy var storageVC = ScrapStorageViewController(viewModel: scrapStorageViewModel)
    let settingVC = SettingViewController()
    
    
    // MARK: - view properties
    
    let scrapPopUpView = ScrapPopUpView()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTabBar()
        setDelegate()
        setNavigation()
        setLayout()
        scrapButtonTapped()
//        realm.resetDB()
    }

    private func setLayout() {
        view.addSubview(scrapPopUpView)
        
        scrapPopUpView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(82)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(83)
        }
    }
    
    private func scrapButtonTapped() {
        scrapPopUpView.snp.updateConstraints { $0.bottom.equalToSuperview() }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.scrapPopUpView.snp.updateConstraints { $0.bottom.equalToSuperview().offset(83) }
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
            })
        }
    }
    
    private func setUpTabBar(){
        self.tabBar.tintColor = .brandColor
        self.tabBar.unselectedItemTintColor = .black
        self.tabBar.isTranslucent = false
        self.tabBar.backgroundColor = .white

        PostsVC.title = TextLiterals.postsViewControllerTitle
        ListVC.title = TextLiterals.listViewControllerTitle
        storageVC.title = TextLiterals.storageViewControllerTitle
        settingVC.title = TextLiterals.settingViewControllerTitle

        let ViewControllers:[UIViewController] = [PostsVC,ListVC,storageVC,settingVC]
        self.setViewControllers(ViewControllers, animated: true)

        PostsVC.tabBarItem.image = ImageLiterals.homeTabIcon
        ListVC.tabBarItem.image = ImageLiterals.listTabIcon
        storageVC.tabBarItem.image = ImageLiterals.unSaveBookMarkIcon
        settingVC.tabBarItem.image = ImageLiterals.settingTabIcon
        
        self.hidesBottomBarWhenPushed = false
        viewWillLayoutSubviews()
    }

    private func setDelegate() {
        delegate = self
        scrapPopUpView.delegate = self
    }
    
    private func setNavigation() {
        self.navigationItem.hidesBackButton = true
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let impactService = HapticService.impact(.light)
        impactService.run()
    }
}

extension TabBarController: ScrapPopUpDelegate {
    func scrapBookButtonTapped() {
        selectedIndex = 2
    }
    
    func folderButtonTapped() {
        let viewModel = ScrapFolderBottomSheetViewModel()
        let folderViewController = ScrapFolderBottomSheetViewController(viewModel: viewModel)
        folderViewController.modalTransitionStyle = .coverVertical
        folderViewController.modalPresentationStyle = .overFullScreen
        self.present(folderViewController, animated: true)
    }
}
