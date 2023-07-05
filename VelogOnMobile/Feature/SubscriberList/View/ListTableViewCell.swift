//
//  ListTableViewCell.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/30.
//

import UIKit

import SnapKit

protocol ListTableViewCellDelegate: AnyObject {
    func unsubscribeButtonDidTap(name: String)
}

final class ListTableViewCell: BaseTableViewCell {
    
    weak var delegate: ListTableViewCellDelegate?
    
    let subscriberImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20.0
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let subscriberLabel: UILabel = {
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
            subscriberLabel,
            unSubscribeButton
        )
        
        subscriberImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.size.equalTo(48)
        }
        
        subscriberLabel.snp.makeConstraints {
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
        selectionStyle = .none
    }
    
    func updateUI(data: SubscriberListResponse) {
        if data.img == "" {
            subscriberImage.image = ImageLiterals.subscriberImage
        } else {
            let subscriberImageURL = URL(string: data.img ?? String())
            subscriberImage.kf.setImage(with: subscriberImageURL)
        }
        subscriberLabel.text = data.name
    }
    
    @objc
    private func unSubscribeButtonTapped() {
        guard let name = subscriberLabel.text else { return }
        delegate?.unsubscribeButtonDidTap(name: name)
    }
}
