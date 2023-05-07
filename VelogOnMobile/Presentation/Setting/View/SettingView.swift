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
        label.font = UIFont(name: "Avenir-Black", size: 30)
        return label
    }()

    private let alertText: UILabel = {
        let label = UILabel()
        label.text = TextLiterals.settingAlertText
        return label
    }()
    
    private let alertSwitch: UISwitch = {
        let alertSwitch = UISwitch()
        return alertSwitch
    }()
    
    private let grayView: UIView = {
        let view = UIView()
        view.backgroundColor = .grayColor
        return view
    }()
    
    private let tableView = SettingTableView()
    
    override func render() {
        self.addSubviews(
            title,
            alertText,
            alertSwitch,
            grayView,
            tableView
        )
        
        title.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.leading.equalToSuperview().offset(20)
        }
        
        alertText.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(62)
            $0.leading.equalToSuperview().offset(35)
        }
        
        alertSwitch.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(alertText)
        }
        
        grayView.snp.makeConstraints {
            $0.top.equalTo(alertText.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(10)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(grayView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(220)
        }
    }
}
