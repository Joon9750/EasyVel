//
//  ListHeadView.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/30.
//

import UIKit

import SnapKit

final class ListHeadView: BaseUIView {
    
    // MARK: - property
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiterals.listTitleLabelText
        label.font = UIFont(name: "Avenir-Black", size: 30)
        return label
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "doc.badge.plus")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    override func render() {
        self.addSubviews(
            titleLabel,
            addButton
        )
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.leading.equalToSuperview().offset(20)
        }
        
        addButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel).offset(5)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.width.equalTo(35)
        }
    }
    
    override func configUI() {
        self.backgroundColor = .white
    }
}
