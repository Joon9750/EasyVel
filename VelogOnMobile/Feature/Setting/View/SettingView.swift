//
//  SettingView.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/01.
//

import UIKit

import SnapKit

final class SettingView: BaseUIView {
    
    private let title: UILabel = {
        let label = UILabel()
        label.text = TextLiterals.settingTitleLabelText
        label.font = .display
        return label
    }()
    
    let tableView = SettingTableView()
    
    override func render() {
        self.addSubviews(
            title,
            tableView
        )
        
        title.snp.makeConstraints {
            $0.top.equalToSuperview().offset(76)
            $0.leading.equalToSuperview().offset(17)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(220)
        }
    }
    
    override func configUI() {
        self.backgroundColor = .white
    }
}
