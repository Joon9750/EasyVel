//
//  SignInView.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/06/18.
//

import UIKit

import SnapKit

final class SignInView: BaseUIView {
    
    let appleSignInButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.backgroundColor = .brandColor
        return button
    }()
    
    override func render() {
        self.addSubview(appleSignInButton)
        
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
