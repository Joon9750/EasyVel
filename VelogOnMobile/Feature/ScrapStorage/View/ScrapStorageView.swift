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
        label.text = "스크랩"
        label.textColor = .black
        label.font = UIFont(name: "Avenir-Black", size: 24)
        return label
    }()
    
    private let vertiLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lineColor
        return view
    }()
    
    let addFolderButton: UIButton = {
        let button = UIButton()
        button.setTitle("폴더 추가", for: .normal)
        button.setTitleColor(UIColor.textGrayColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Black", size: 15)
        button.backgroundColor = .white
        return button
    }()
    
    private let horiLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lineColor
        return view
    }()
    
    let editButton: UIButton = {
        let button = UIButton()
        button.setTitle("편집", for: .normal)
        button.setTitleColor(UIColor.textGrayColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Black", size: 15)
        button.backgroundColor = .white
        return button
    }()
    
    let scarpCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (SizeLiterals.screenWidth - 40) / 2, height: (SizeLiterals.screenWidth - 30) / 2 + 35)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cell: ScrapStorageCollectionViewCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        collectionView.showsVerticalScrollIndicator = true
        return collectionView
    }()
    
    override func configUI() {
        self.backgroundColor = .white
    }

    override func render() {
        self.addSubviews(
            titleLabel,
            vertiLineView,
            addFolderButton,
            horiLineView,
            editButton,
            scarpCollectionView
        )

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(94)
            $0.leading.equalToSuperview().offset(20)
        }
        
        vertiLineView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        addFolderButton.snp.makeConstraints {
            $0.top.equalTo(vertiLineView.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().inset(74)
            $0.height.equalTo(20)
            $0.width.equalTo(60)
        }
        
        horiLineView.snp.makeConstraints {
            $0.height.equalTo(15)
            $0.width.equalTo(1)
            $0.leading.equalTo(addFolderButton.snp.trailing).offset(14)
            $0.centerY.equalTo(addFolderButton)
        }
        
        editButton.snp.makeConstraints {
            $0.top.equalTo(vertiLineView.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(20)
            $0.width.equalTo(26)
        }
        
        scarpCollectionView.snp.makeConstraints {
            $0.top.equalTo(addFolderButton.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
