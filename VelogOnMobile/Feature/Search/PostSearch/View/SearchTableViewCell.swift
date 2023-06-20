//
//  SearchTableViewCell.swift
//  VelogOnMobile
//
//  Created by JuHyeonAh on 2023/06/08.
//
import UIKit

import SnapKit

final class SearchTableViewCell: BaseTableViewCell {
    
    static let identifier = "SearchTableViewCell"
    
    let numLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray700
        label.font = .body_1_B
        return label
    }()
    
    private let keywordLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray700
        label.font = .body_1_M
        return label
    }()
    
    override func render() {
        contentView.addSubviews(
            keywordLabel,
            numLabel
        )
        
        numLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().inset(5)
            $0.leading.equalToSuperview().offset(5)
            $0.width.equalTo(30)
            $0.height.equalTo(30)
        }
        
        keywordLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalTo(numLabel).offset(30)
            $0.height.equalTo(30)
        }
    }
    
    func configCell(_ trend: Trend) {
        keywordLabel.text = trend.keyword
        numLabel.text = trend.num
    }
}
