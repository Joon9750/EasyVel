//
//  ShowToast.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/06/26.
//

import UIKit
import SnapKit

extension UIViewController {
    func showToast(
        toastText: String,
        backgroundColor: UIColor
    ) {
        Toast.show(
            toastText: toastText,
            toastBackgroundColor: backgroundColor,
            controller: self
        )
    }
}

final class Toast {
    static func show(
        toastText: String,
        toastBackgroundColor: UIColor,
        controller: UIViewController
    ) {
        
        let toastContainer = UIView()
        let toastLabel = UILabel()
        
        toastLabel.text = toastText
        toastLabel.textColor = .white
        toastLabel.font = .body_2_M
        toastLabel.textAlignment = .center
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = 0
        toastLabel.sizeToFit()
        
        
        toastContainer.layer.cornerRadius = 24
        toastContainer.alpha = 1.0
        toastContainer.backgroundColor = toastBackgroundColor
        toastContainer.clipsToBounds = true
        toastContainer.isUserInteractionEnabled = false
        
        toastContainer.addSubview(toastLabel)
        controller.view.addSubview(toastContainer)
        
        toastContainer.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(36)
            $0.leading.trailing.equalToSuperview().inset(51)
            $0.height.equalTo(48)
        }
        
        toastLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.4, delay: 1.0, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
}
