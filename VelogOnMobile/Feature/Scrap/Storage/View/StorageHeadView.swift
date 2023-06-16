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
        label.font = UIFont(name: "Avenir-Black", size: 16)
        label.textColor = .black
        return label
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        return view
    }()
    
    let gray100View: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    let deleteFolderButton : UIButton = {
        let button = UIButton()
        button.setTitle("폴더 삭제", for: .normal)
        button.setTitleColor(.gray300, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Black", size: 15)
        button.backgroundColor = .gray100
        return button
    }()

    let changeFolderNameButton: UIButton = {
        let button = UIButton()
        button.setTitle("이름 변경", for: .normal)
        button.setTitleColor(.gray300, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Black", size: 15)
        button.backgroundColor = .gray100
        return button
    }()
    
    override func render() {
        self.addSubviews(
            titleLabel,
            lineView,
            gray100View
        )
        
        gray100View.addSubviews(
            changeFolderNameButton,
            deleteFolderButton
        )
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(78)
            $0.centerX.equalToSuperview()
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
        }
        
        gray100View.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        deleteFolderButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }

        changeFolderNameButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(96)
        }
    }
    
    override func configUI() {
        self.backgroundColor = .white
    }
}
