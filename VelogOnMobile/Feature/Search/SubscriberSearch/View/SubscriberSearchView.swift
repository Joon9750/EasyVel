//
//  SubscriberSearchView.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//

import UIKit

import SnapKit

final class SubscriberSearchView: BaseUIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiterals.searchSubscriberTitle
        label.textColor = .gray700
        label.font = .subhead
        return label
    }()
    
    let addSubscriberBtn: UIButton = {
        let button = UIButton()
        button.setTitle(TextLiterals.addButtonText, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.backgroundColor = .brandColor
        button.titleLabel?.font = UIFont(name: "Apple SD Gothic Neo", size: 16)
        return button
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .gray700
        return button
    }()
    
    let searchSubscriberTextFieldAddImageView: UIImageView = {
        let imageView = UIImageView(image: ImageLiterals.subscriberAddIcon)
        imageView.backgroundColor = .gray100
        return imageView
    }()
    
    let searchSubscriberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "팔로우를 추가해보시오."
        textField.font = .body_1_M
        textField.backgroundColor = .gray100
        textField.addLeftPadding(leftPaddingWidth: 35)
        return textField
    }()
    
    let addSubscriberButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .brandColor
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .body_1_M
        button.layer.cornerRadius = 10
        return button
    }()
    
    let searchStatusLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiterals.noneText
        label.textColor = UIColor.red
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 13)
        return label
    }()
    
    override func render() {
        setTextField()

        self.addSubviews(
            titleLabel,
            dismissButton,
            searchSubscriberTextField,
            addSubscriberButton,
            searchStatusLabel
        )
        
        searchSubscriberTextField.addSubview(searchSubscriberTextFieldAddImageView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
        }
        
        dismissButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(24)
        }
        
        searchSubscriberTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(90)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(93)
            $0.height.equalTo(36)
        }
        
        addSubscriberButton.snp.makeConstraints {
            $0.centerY.equalTo(searchSubscriberTextField)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(32)
            $0.width.equalTo(50)
        }
        
        searchStatusLabel.snp.makeConstraints {
            $0.top.equalTo(addSubscriberButton.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(60)
        }
        
        searchSubscriberTextFieldAddImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(16)
            $0.leading.equalToSuperview().inset(12)
        }
    }
    
    override func configUI() {
        self.backgroundColor = .white
    }
        
    func setTextField(){
        searchSubscriberTextField.autocapitalizationType = .none
        searchSubscriberTextField.borderStyle = UITextField.BorderStyle.none
        searchSubscriberTextField.clearButtonMode = .always
    }
}
