//
//  SignInView.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/06/18.
//

import UIKit

import AuthenticationServices
import SnapKit

final class SignInView: BaseUIView {
    
    let appleSignInButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.backgroundColor = .brandColor
        return button
    }()
    
    let realAppleSignInButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    
    override func render() {
        self.addSubviews(
            realAppleSignInButton,
            appleSignInButton
        )
        
        realAppleSignInButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        appleSignInButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(30)
        }
    }
    
    override func configUI() {
        self.backgroundColor = .white
    }
}
