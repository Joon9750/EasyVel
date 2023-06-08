//
//  TabBarController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//

import UIKit

import SnapKit
import RxSwift
import RxRelay

import RealmSwift
import Realm

final class TabBarController: UITabBarController {

    // MARK: - viewModel properties
    
    let listViewModel = ListViewModel()
    let scrapStorageViewModel = ScrapStorageViewModel()
    
    // MARK: - viewController properties
    
    let homeVC = HomeViewController()
    lazy var listVC = ListViewController(viewModel: listViewModel)
    lazy var storageVC = ScrapStorageViewController(viewModel: scrapStorageViewModel)
    let settingVC = SettingViewController()
    
    
    // MARK: - view properties
    
    let scrapPopUpView = ScrapPopUpView()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTabBar()
        setDelegate()
        setLayout()
        setNotificationCenter()
//        self.resetDB()
    }
    
    private func setLayout() {
        view.addSubview(scrapPopUpView)
        
        scrapPopUpView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(82)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(83)
        }
    }
    
    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: Notification.Name("ScrapButtonTappedNotification"), object: nil)
    }
    
    @objc
    private func handleNotification(_ notification: Notification) {
        if let data = notification.userInfo?["data"] as? StoragePost {
            scrapPopUpView.getPostData(post: data)
        }
        scrapPopUpView.snp.updateConstraints { $0.bottom.equalToSuperview()
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.scrapPopUpView.snp.updateConstraints { $0.bottom.equalToSuperview().offset(83)
                }
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

        homeVC.title = TextLiterals.homeViewControllerTitle
        listVC.title = TextLiterals.listViewControllerTitle
        storageVC.title = TextLiterals.storageViewControllerTitle
        settingVC.title = TextLiterals.settingViewControllerTitle

        let ViewControllers:[UIViewController] = [homeVC,listVC,storageVC,settingVC]
        self.setViewControllers(ViewControllers, animated: true)

        homeVC.tabBarItem.image = ImageLiterals.homeTabIcon
        listVC.tabBarItem.image = ImageLiterals.listTabIcon
        storageVC.tabBarItem.image = ImageLiterals.unSaveBookMarkIcon
        settingVC.tabBarItem.image = ImageLiterals.settingTabIcon
        
        self.hidesBottomBarWhenPushed = false
        viewWillLayoutSubviews()
    }

    private func setDelegate() {
        delegate = self
        scrapPopUpView.delegate = self
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
    
    func folderButtonTapped(scrapPost: StoragePost) {
        let viewModel = ScrapFolderBottomSheetViewModel()
        viewModel.selectedScrapPostAddInFolder.accept(scrapPost)
        let folderViewController = ScrapFolderBottomSheetViewController(viewModel: viewModel)
        folderViewController.modalPresentationStyle = .pageSheet
        self.present(folderViewController, animated: true)
    }
}

extension TabBarController {
    // 스키마 수정시 한번 돌려야 한다.
    func resetDB(){
        let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
        let realmURLs = [
          realmURL,
          realmURL.appendingPathExtension("lock"),
          realmURL.appendingPathExtension("note"),
          realmURL.appendingPathExtension("management")
        ]

        for URL in realmURLs {
          do {
            try FileManager.default.removeItem(at: URL)
          } catch {
            // handle error
          }
        }
    }
}
