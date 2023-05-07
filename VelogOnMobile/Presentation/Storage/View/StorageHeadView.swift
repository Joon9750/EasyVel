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
        button.setImage(
            UIImage(systemName:"plus")?.withTintColor(.brandColor, renderingMode: .alwaysOriginal),
            for: .normal
        )
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
            $0.trailing.equalToSuperview().inset(30)
            $0.height.width.equalTo(25)
        }
    }
    
    override func configUI() {
        self.backgroundColor = .white
    }
}
