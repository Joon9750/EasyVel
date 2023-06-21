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
    
    let folderIcon = UIImageView(image: ImageLiterals.scrapFolderIcon)
    
    let folderNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray700
        label.font = .body_2_M
        return label
    }()
    
    private let postCount: UILabel = {
        let label = UILabel()
        label.textColor = .gray300
        label.font = .caption_1_M
        return label
    }()
    
    override func configUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
    }
    
    override func render() {
        contentView.addSubviews(
            folderIcon,
            folderNameLabel,
            postCount
        )
        
        folderIcon.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(22)
            $0.width.equalTo(28)
        }
        
        folderNameLabel.snp.makeConstraints {
            $0.top.equalTo(folderIcon.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
        }
        
        postCount.snp.makeConstraints {
            $0.top.equalTo(folderNameLabel.snp.bottom).offset(3)
            $0.leading.equalTo(folderNameLabel.snp.leading)
        }
    }

    func updateTable(
        folderData: StorageDTO,
        folderImage: String,
        folderPostsCount: Int
    ) {
        folderNameLabel.text = folderData.folderName
        postCount.text = String(folderPostsCount) + TextLiterals.postInFolderCountText
    }
}
