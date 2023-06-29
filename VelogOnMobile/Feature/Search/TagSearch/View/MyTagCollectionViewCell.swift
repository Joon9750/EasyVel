//
//  MyTagCollectionViewCell.swift
//  VelogOnMobile
//
//  Created by 장석우 on 2023/06/30.
//

import UIKit

import SnapKit

final class MyTagCollectionViewCell: BaseCollectionViewCell {
    
    //MARK: - Properties
    
    private var keyword: String? {
        didSet {
            updateUI()
        }
    }
    
    //MARK: - UI Components
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .body_2_M
        return label
    }()
    
    private let xButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.xMarkIcon, for: .normal)
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
    
    func dataBind(data: String) {
        self.keyword = data
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
            $0.leading.equalToSuperview().inset(12)
        }
        
        xButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(tagLabel.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
    func updateUI() {
        tagLabel.text = keyword
    }
    
}

