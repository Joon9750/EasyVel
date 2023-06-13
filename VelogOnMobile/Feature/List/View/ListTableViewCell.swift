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
    
    let subscriberImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        return imageView
    }()
    
    let listText: UILabel = {
        let label = UILabel()
        label.tintColor = .black
        label.font = UIFont(name: "Avenir-Black", size: 16)
        return label
    }()
    
    let unSubscribeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .brandColor
        button.setTitle("구독취소", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Black", size: 12)
        button.layer.cornerRadius = 10
        return button
    }()
    
    
    override func render() {
        self.addSubviews(
            subscriberImage,
            listText,
            unSubscribeButton
        )
        
        subscriberImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.size.equalTo(48)
        }
        
        listText.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(subscriberImage.snp.trailing).offset(12)
        }
        
        unSubscribeButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(24)
            $0.width.equalTo(70)
        }
    }
}
