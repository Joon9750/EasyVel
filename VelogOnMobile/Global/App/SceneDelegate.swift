//
//  SceneDelegate.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//

import UIKit

import RealmSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var errorWindow: UIWindow?
    private var networkMonitor: NetworkMonitor = NetworkMonitor()
    private var realm = RealmService()


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        // MARK: - check network
        
        startMonitoringNetwork(on: scene)
        
        // MARK: - realm folder
        
        if checkAllPostIsUnique() {
            addInitialData()
        }
        
        // MARK: - fix me : set access token
        
        if realm.getAccessToken() == "" {
            // MARK: - 초기 유저
            let signInViewModel = SignInViewModel()
            let rootViewController = UINavigationController(rootViewController: SignInViewController(viewModel: signInViewModel))
            window?.rootViewController = rootViewController
            window?.makeKeyAndVisible()
            return
        }
        
        // MARK: - check auto signIn
        
        if realm.checkIsUserSignIn() {
            // MARK: - 자동 로그인 된 유저
            let testVC = UINavigationController(rootViewController: TagSearchViewController(viewModel: TagSearchViewModel()))
            let rootViewController = UINavigationController(rootViewController: TabBarController())
            window?.rootViewController = testVC
            window?.makeKeyAndVisible()
            return
        } else {
            // MARK: - 자동 로그인 이후 로그아웃한 유저
            let signInViewModel = SignInViewModel()
            let rootViewController = UINavigationController(rootViewController: SignInViewController(viewModel: signInViewModel))
            window?.rootViewController = rootViewController
            window?.makeKeyAndVisible()
            return
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

// MARK: network

private extension SceneDelegate {
    func startMonitoringNetwork(on scene: UIScene) {
        networkMonitor.startMonitoring(statusUpdateHandler: { [weak self] connectionStatus in
            switch connectionStatus {
            case .satisfied: self?.removeNetworkErrorWindow()
            case .unsatisfied: self?.loadNetworkErrorWindow(on: scene)
            default: break
            }
        })
    }
    
    func removeNetworkErrorWindow() {
        DispatchQueue.main.async { [weak self] in
            self?.errorWindow?.resignKey()
            self?.errorWindow?.isHidden = true
            self?.errorWindow = nil
        }
    }
    
    func loadNetworkErrorWindow(on scene: UIScene) {
        if let windowScene = scene as? UIWindowScene {
            DispatchQueue.main.async { [weak self] in
                let window = UIWindow(windowScene: windowScene)
                window.windowLevel = .statusBar
                window.makeKeyAndVisible()
                let noNetworkView = NoNetworkView(frame: window.bounds)
                window.addSubview(noNetworkView)
                self?.errorWindow = window
            }
        }
    }
}

// MARK: - realm

private extension SceneDelegate {
    func addInitialData() {
        guard let realm = try? Realm() else { return }
        let storageDTO = StorageDTO(
            articleID: UUID(),
            folderName: "모든 게시글",
            count: 0
        )
        let scrapStorageDTO = ScrapStorageDTO(input: storageDTO)
        try! realm.write {
            realm.add(scrapStorageDTO)
        }
    }
    
    func checkAllPostIsUnique() -> Bool {
        guard let realm = try? Realm() else { return Bool() }
        let folderName = "모든 게시글"
        let folder = realm.objects(ScrapStorageDTO.self).filter("folderName == %@", folderName)
        return folder.isEmpty
    }
}
