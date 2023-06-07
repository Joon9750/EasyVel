//
//  ScrapStorageCollectionViewCell.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/29.
//

import UIKit

import SnapKit
import Kingfisher

final class ScrapStorageCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Properties
    
    static var identifier: String = "ScrapStorageCollectionViewCell"
    
    // MARK: - UI Components
    
    private let imageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "xmark.rectangle.fill")
        imageView.layer.cornerRadius = 6
        imageView.layer.maskedCorners = [.layerMinXMinYCorner]
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let imageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "xmark.rectangle.fill")
        imageView.layer.cornerRadius = 6
        imageView.layer.maskedCorners = [.layerMaxXMinYCorner]
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let imageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "xmark.rectangle.fill")
        imageView.layer.cornerRadius = 6
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner]
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let imageView4: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "xmark.rectangle.fill")
        imageView.layer.cornerRadius = 6
        imageView.layer.maskedCorners = [.layerMaxXMaxYCorner]
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let horizontalStackView1: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let horizontalStackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let allStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        return stackView
    }()
    
    let folderNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Avenir-Black", size: 15)
        return label
    }()
    
    private let postCount: UILabel = {
        let label = UILabel()
        label.textColor = .darkGrayColor
        label.font = UIFont(name: "Avenir-Black", size: 13)
        return label
    }()
    
    override func render() {
        contentView.addSubviews(
            imageView1,
            imageView2,
            imageView3,
            imageView4,
            horizontalStackView1,
            horizontalStackView2,
            allStackView,
            folderNameLabel,
            postCount
        )
        
        horizontalStackView1.addSubviews(
            imageView1,
            imageView2
        )
        
        horizontalStackView2.addSubviews(
            imageView3,
            imageView4
        )
        
        allStackView.addSubviews(
            horizontalStackView1,
            horizontalStackView2
        )
        
        imageView1.snp.makeConstraints {
            $0.size.equalTo(SizeLiterals.screenWidth * 92 / 390)
            $0.leading.equalToSuperview()
        }

        imageView2.snp.makeConstraints {
            $0.size.equalTo(SizeLiterals.screenWidth * 92 / 390)
            $0.trailing.equalToSuperview()
        }

        imageView3.snp.makeConstraints {
            $0.size.equalTo(SizeLiterals.screenWidth * 92 / 390)
            $0.leading.equalToSuperview()
        }

        imageView4.snp.makeConstraints {
            $0.size.equalTo(SizeLiterals.screenWidth * 92 / 390)
            $0.trailing.equalToSuperview()
        }

        horizontalStackView1.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.equalTo(contentView.snp.width)
            $0.height.equalTo(imageView3.snp.width)
        }
        
        horizontalStackView2.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.width.equalTo(contentView.snp.width)
            $0.height.equalTo(imageView3.snp.width)
        }
        
        allStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(contentView.snp.width)
        }
        
        folderNameLabel.snp.makeConstraints {
            $0.top.equalTo(allStackView.snp.bottom).offset(3)
            $0.leading.equalToSuperview().offset(20)
        }
        
        postCount.snp.makeConstraints {
            $0.top.equalTo(folderNameLabel.snp.bottom)
            $0.leading.equalTo(folderNameLabel.snp.leading)
        }
    }
    
    public func configure(
        folderData: StorageDTO,
        folderImage: String
    ) {
        updateTable(
            folderData: folderData,
            folderImage: folderImage
        )
    }
    
    private func updateTable(
        folderData: StorageDTO,
        folderImage: String
    ) {
        folderNameLabel.text = folderData.folderName
        if let count = folderData.count {
            postCount.text = String(count) + "개"
        }
        imageView1.kf.setImage(with: URL(string: folderImage))
    }
}
