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
    
    let velogLogoImageView = UIImageView(image: ImageLiterals.signInViewImage)
    
    let appleSignInButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    
    override func render() {
        
        self.addSubviews(
            velogLogoImageView,
            appleSignInButton
        )
        
        velogLogoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-70)
            $0.height.equalTo(204)
            $0.width.equalTo(165)
        }
        
        appleSignInButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(98)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(52)
        }
    }
    
    override func configUI() {
        velogLogoImageView.contentMode = .scaleAspectFit
        self.backgroundColor = .brandColor
    }
}
