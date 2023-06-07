//
//  StorageHeadView.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/04.
//

import UIKit

import SnapKit

final class StorageHeadView: BaseUIView {
    
    // MARK: - property
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Black", size: 24)
        return label
    }()
    
    override func render() {
        self.addSubviews(
            titleLabel
        )
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(95)
            $0.leading.equalToSuperview().offset(20)
        }
    }
    
    override func configUI() {
        self.backgroundColor = .white
    }
}
