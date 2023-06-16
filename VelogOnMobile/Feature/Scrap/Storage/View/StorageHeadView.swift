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
        label.font = UIFont(name: "Avenir-Black", size: 20)
        label.textColor = .black
        return label
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let deleteFolderButton : UIButton = {
        let button = UIButton()
        button.setTitle("폴더 삭제", for: .normal)
        button.setTitleColor(UIColor.textGrayColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Black", size: 15)
        button.backgroundColor = .white
        return button
    }()

    let changeFolderNameButton: UIButton = {
        let button = UIButton()
        button.setTitle("이름 변경", for: .normal)
        button.setTitleColor(UIColor.textGrayColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Black", size: 15)
        button.backgroundColor = .white
        return button
    }()
    
    override func render() {
        self.addSubviews(
            titleLabel,
            lineView,
            changeFolderNameButton,
            deleteFolderButton
        )
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(130)
            $0.leading.equalToSuperview().offset(20)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
        }
        
        deleteFolderButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(20)
        }

        changeFolderNameButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(96)
        }
    }
    
    override func configUI() {
        self.backgroundColor = .white
    }
}
