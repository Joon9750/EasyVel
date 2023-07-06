//
//  SettingView.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/30.
//

import UIKit

import SnapKit

final class SettingTableViewCell: BaseTableViewCell {
    
    static let cellId = "cellId"
    
    // MARK: - property
    
    let buttonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray500
        label.font = .body_2_M
        return label
    }()
    
    override func render() {
        self.backgroundColor = .clear
        self.addSubview(buttonLabel)
        
        buttonLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(35)
            $0.centerY.equalToSuperview()
        }
    }
}
