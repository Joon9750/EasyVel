//
//  NoNetworkView.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//

import UIKit

import SnapKit

final class NoNetworkView: BaseUIView {
    
    // MARK: - network fail 이미지 추가
    private let networkfailImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override func configUI() {
        self.backgroundColor = .white
    }
    
    override func render() {
        self.addSubview(networkfailImageView)
        networkfailImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
