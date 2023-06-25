//
//  ListHeadView.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/30.
//

import UIKit

import SnapKit

final class ListHeadView: BaseUIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiterals.listTitleLabelText
        label.font = .display
        return label
    }()
    
    let searchSubscriberButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.searchIcon, for: .normal)
        return button
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiterals.subscriberListViewSubTitleLabel
        label.font = .body_2_B
        return label
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        return view
    }()
    
    private let pointLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .brandColor
        return view
    }()
    
    override func render() {
        self.addSubviews(
            titleLabel,
            searchSubscriberButton,
            subTitleLabel,
            lineView,
            pointLineView
        )
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(76)
            $0.leading.equalToSuperview().offset(17)
        }
        
        searchSubscriberButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(22)
            $0.size.equalTo(30)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(27)
            $0.leading.equalToSuperview().offset(20)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(171)
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
        }
        
        pointLineView.snp.makeConstraints {
            $0.centerY.equalTo(lineView)
            $0.height.equalTo(3)
            $0.width.equalTo(121)
            $0.leading.equalToSuperview().offset(12)
        }
    }
    
    override func configUI() {
        self.backgroundColor = .white
    }
}
