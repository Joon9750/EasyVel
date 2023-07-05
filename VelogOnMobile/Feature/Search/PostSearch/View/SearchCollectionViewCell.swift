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
        return label
    }()
    
    //MARK: - Life Cycle
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        contentView.makeRounded(ratio: 2)
    }
    
    override func render() {
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.gray200.cgColor
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(searchwordLabel)
        
        searchwordLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(25)
            
        }
        
    }
    
    //MARK: - Custom Method
    
    func configCell(_ currentTag: String) {
        searchwordLabel.text = currentTag
        
    }
}
