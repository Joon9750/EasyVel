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
    
    let deleteFolderButton : UIButton = {
        let button = UIButton()
        button.setTitle("폴더 삭제", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Black", size: 15)
        return button
    }()
    
    override func render() {
        self.addSubviews(
            titleLabel,
            deleteFolderButton
        )
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(95)
            $0.leading.equalToSuperview().offset(20)
        }
        
        deleteFolderButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    override func configUI() {
        self.backgroundColor = .white
    }
}
