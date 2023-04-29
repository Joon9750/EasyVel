//
//  ListTableViewCell.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//

import UIKit

import SnapKit

final class ListTableViewCell: BaseTableViewCell {
    
    static let identifier = "ListTableViewCell"
    
    var subscriberName: UILabel = {
        let label = UILabel()
        label.text = "홍준혁"
        label.tintColor = .black
        return label
    }()
    
    override func render() {
        self.addSubview(subscriberName)
        
        subscriberName.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
    }
}
