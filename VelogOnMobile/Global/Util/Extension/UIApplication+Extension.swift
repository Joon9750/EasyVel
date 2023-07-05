//
//  UIApplication+Extension.swift
//  VelogOnMobile
//
//  Created by 장석우 on 2023/07/06.
//

import UIKit

extension UIApplication {
    
    var firstWindow: UIWindow? {
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        return windowScenes?.windows.filter { $0.isKeyWindow }.first
    }
    
    var rootViewController: UIViewController? {
        return firstWindow?.rootViewController
    }
    
    func changeRootViewController(_ viewController: UIViewController) {
        guard let firstWindow = firstWindow else {
            print("윈도우 생성 전입니다.")
            return
        }
        
        firstWindow.rootViewController = viewController
        firstWindow.makeKeyAndVisible()
        UIView.transition(with: firstWindow,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: nil)
    }
}

