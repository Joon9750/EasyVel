//
//  SearchCollectionViewCell.swift
//  VelogOnMobile
//
//  Created by JuHyeonAh on 2023/06/08.
//
import UIKit

import SnapKit

final class SearchCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "SearchCell"
    
    private let searchwordLabel : UILabel = {
        let label = UILabel()
        label.font = .caption_1_M
        label.textAlignment = .center
        label.textColor = .gray700
        label.layer.borderWidth = 1.0
        label.layer.borderColor = UIColor.gray200.cgColor
        label.layer.cornerRadius = 10.0
        label.layer.masksToBounds = true
        return label
    }()
    
    override func render() {
        contentView.addSubview(searchwordLabel)
        
        searchwordLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(3)
            $0.height.equalTo(25)
        }
    }
    
    func configCell(_ trend: String) {
        searchwordLabel.text = trend
    }
}
