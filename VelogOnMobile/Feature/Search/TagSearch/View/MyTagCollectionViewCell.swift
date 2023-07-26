//
//  MyTagCollectionViewCell.swift
//  VelogOnMobile
//
//  Created by 장석우 on 2023/06/30.
//

import UIKit

import SnapKit

final class MyTagCollectionViewCell: BaseCollectionViewCell {
    
    //MARK: - UI Components
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .body_1_M
        return label
    }()
    
    private let xButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.xMarkIcon, for: .normal)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    //MARK: - Life Cycle

    override func render() {
        self.contentView.backgroundColor = .brandColor
        
        hierarchy()
        layout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.makeRounded(ratio: 2)
    }
    
    //MARK: - Public Method
    
    func updateUI(keyword: String) {
        tagLabel.text = keyword
    }
}

//MARK: - Private Method

private extension MyTagCollectionViewCell {
    func hierarchy() {
        contentView.addSubviews(tagLabel,
                                xButton)
    }
    
    func layout() {
        tagLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(15)
        }
        
        xButton.snp.makeConstraints {
            $0.centerY.equalTo(tagLabel)
            $0.leading.equalTo(tagLabel.snp.trailing).offset(5)
            $0.trailing.equalToSuperview().inset(10)
        }
    }
}
