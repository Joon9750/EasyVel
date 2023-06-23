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
    
    var unSubscribeButtonDidTap: ((String) -> Void)?
    
    let subscriberImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.subscriberImage
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    let listText: UILabel = {
        let label = UILabel()
        label.tintColor = .gray700
        label.font = .body_2_M
        return label
    }()
    
    lazy var unSubscribeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .brandColor
        button.setTitle(TextLiterals.subscriberListViewUnSubscribeButtonText, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .caption_1_B
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(unSubscribeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func render() {
        self.contentView.addSubviews(
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
            $0.width.equalTo(80)
        }
    }
    
    override func configUI() {
        self.backgroundColor = .gray100
    }
    
    @objc
    private func unSubscribeButtonTapped() {
        if let subscriberName = listText.text {
            unSubscribeButtonDidTap?(subscriberName)
        }
    }
}
