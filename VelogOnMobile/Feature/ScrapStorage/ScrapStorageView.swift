//
//  ScarpView.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/29.
//

import UIKit

import SnapKit

final class ScrapStorageView: BaseUIView {

    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "스크랩북"
        label.textColor = .black
        label.font = UIFont(name: "Avenir-Black", size: 18)
        return label
    }()
    
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 7
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let userNicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "Nickname"
        label.textColor = .darkGray
        label.font = UIFont(name: "Avenir-Black", size: 12)
        return label
    }()
    
    private let userStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        return stackView
    }()
    
    let editButton: UIButton = {
        let button = UIButton()
        button.setTitle("편집", for: .normal)
        button.setTitleColor(UIColor.darkGrayColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Black", size: 14)
        button.backgroundColor = .white
        return button
    }()
    
    private let scarpCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (SizeLiterals.screenWidth - 30) / 2, height: (SizeLiterals.screenWidth - 30) / 2 + 35)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(
            ScrapStorageCollectionViewCell.self,
            forCellWithReuseIdentifier: ScrapStorageCollectionViewCell.identifier
        )
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    override func setLayout() {
        self.addSubviews(
            titleLabel,
            userImageView,
            userNicknameLabel,
            userStackView,
            editButton,
            scarpCollectionView
        )
        
        userStackView.addArrangedSubviews(
            userImageView,
            userNicknameLabel
        )
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
        }
        
        userImageView.snp.makeConstraints {
            $0.size.equalTo(14)
        }
        
        userNicknameLabel.snp.makeConstraints {
            $0.height.equalTo(14)
        }

        userStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(13)
            $0.centerX.equalToSuperview()
        }
        
        editButton.snp.makeConstraints {
            $0.top.equalTo(userStackView.snp.bottom)
            $0.trailing.equalToSuperview().inset(14)
            $0.width.equalTo(26)
            $0.height.equalTo(15)
        }
        
        scarpCollectionView.snp.makeConstraints {
            $0.top.equalTo(editButton.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
