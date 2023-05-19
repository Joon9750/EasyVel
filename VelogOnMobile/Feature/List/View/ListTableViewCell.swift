//
//  ListTableViewCell.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/30.
//

import UIKit

import SnapKit

final class ListTableViewCell: BaseTableViewCell {
    
    static let identifier = "ListTableViewCell"
    
    var listText: UILabel = {
        let label = UILabel()
        label.tintColor = .black
        return label
    }()
    
    override func render() {
        self.addSubview(listText)
        
        listText.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
    }
}
