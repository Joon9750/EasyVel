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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Storage"
        label.font = UIFont(name: "Avenir-Black", size: 30)
        return label
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    override func render() {
        self.addSubviews(
            titleLabel,
            deleteButton
        )
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.leading.equalToSuperview().offset(20)
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel).offset(10)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(25)
            $0.width.equalTo(50)
        }
    }
    
    override func configUI() {
        self.backgroundColor = .white
    }
}
