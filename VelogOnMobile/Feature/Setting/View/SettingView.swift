//
//  SettingView.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/01.
//

import UIKit

import SnapKit

final class SettingView: BaseUIView {
    
    private let headView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiterals.settingTitleLabelText
        label.textColor = .gray700
        label.font = .display
        return label
    }()
    
    private let vertiLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        return view
    }()
    
    
    let tableView = SettingTableView()
    
    override func render() {
        
        self.addSubviews(
            headView,
            tableView
        )
        
        headView.addSubviews(
            titleLabel,
            vertiLineView
        )
        
        
        headView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(171)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(32)
            $0.leading.equalToSuperview().offset(20)
        }
        
        vertiLineView.snp.makeConstraints {
            $0.top.equalTo(headView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(vertiLineView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    override func configUI() {
        self.backgroundColor = .white
    }
}
