//
//  TabBarController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//

import UIKit

import SnapKit
<<<<<<< HEAD
import RealmSwift

final class TabBarController: UITabBarController {
=======
import RxSwift
import RxRelay

import RealmSwift
import Realm

final class TabBarController: UITabBarController {

    private let localRealm = try! Realm()
>>>>>>> master

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
<<<<<<< HEAD
        scrapButtonTapped()
        resetDB()
=======
//        scrapButtonTapped()
        setNotificationCenter()
//        self.resetDB()
>>>>>>> master
    }
    
    private func setLayout() {
        view.addSubview(scrapPopUpView)

        scrapPopUpView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(82)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(83)
        }
    }
<<<<<<< HEAD

=======
    
    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(scrapButtonTapped), name: Notification.Name("ScrapButtonTappedNotification"), object: nil)
    }
    
    @objc
>>>>>>> master
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

    private func resetDB(){
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
