//
//  SearchTableViewCell.swift
//  VelogOnMobile
//
//  Created by JuHyeonAh on 2023/05/31.
//

import UIKit
import SnapKit

final class SearchTableViewCell: UITableViewCell {

    
    static let identifier = "SearchTableViewCell"
    
    private let numLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 16)
        label.font = UIFont.boldSystemFont(ofSize: 16)

        return label
    }()
    

    private let keywordLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 16)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        
        return label
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        contentView.addSubview(keywordLabel)
        contentView.addSubview(numLabel)
        
        numLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(5)
            $0.bottom.equalTo(contentView).offset(-5)
            $0.leading.equalTo(contentView).offset(5)
            $0.width.equalTo(30)
            $0.height.equalTo(30)
        }
        
        keywordLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(5)
            $0.leading.equalTo(numLabel).offset(30)
            $0.height.equalTo(30)
        }
    }
    
    func configCell(_ trend: Trend) {
        keywordLabel.text = trend.keyword
        numLabel.text = trend.num
        
    }

}
