//
//  StorageView.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/04.
//

import UIKit

import SnapKit

final class StorageView: BaseUIView {
    
    let listTableView = StorageTableView(frame: .null, style: .insetGrouped)
    let storageHeadView = StorageHeadView()
    let moveToTopButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.backgroundColor = .brandColor
        button.alpha = 0.8
        button.isHidden = true
        button.setImage(UIImage(systemName: "arrow.uturn.up")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    override func render() {
        self.addSubviews(
            storageHeadView,
            listTableView,
            moveToTopButton
        )
        
        storageHeadView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(120)
        }
        
        listTableView.snp.makeConstraints {
            $0.top.equalTo(storageHeadView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        moveToTopButton.snp.makeConstraints {
            $0.height.width.equalTo(45)
            $0.bottom.trailing.equalToSuperview().inset(30)
        }
    }
}
