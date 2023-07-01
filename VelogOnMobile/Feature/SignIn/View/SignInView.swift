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
    
    let signInViewImage = UIImageView(image: ImageLiterals.signInViewImage)
    
    let appleSignInButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.backgroundColor = .gray100
        return button
    }()
    
    let realAppleSignInButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    
    override func render() {
        self.addSubviews(
            signInViewImage,
            realAppleSignInButton,
            appleSignInButton
        )
        
        signInViewImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(233)
            $0.height.equalTo(204)
            $0.width.equalTo(148)
        }
        
        realAppleSignInButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
            $0.bottom.equalToSuperview().inset(98)
        }
        
        appleSignInButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(150)
        }
    }
    
    override func configUI() {
        self.backgroundColor = .brandColor
    }
}
