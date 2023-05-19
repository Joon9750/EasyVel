//
//  NoNetworkView.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//

import UIKit

import SnapKit

final class NoNetworkView: BaseUIView {
    
    private let networkfailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.networkFail
        return imageView
    }()
    
    override func configUI() {
        self.backgroundColor = .white
    }
    
    override func render() {
        self.addSubview(networkfailImageView)
    
        networkfailImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(134)
            $0.width.equalTo(212)
        }
    }
}
