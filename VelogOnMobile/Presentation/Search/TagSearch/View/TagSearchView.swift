//
//  KeywordSearchView.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/30.
//

import UIKit

import SnapKit

final class TagSearchView: BaseUIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Search Keyword"
        label.font = UIFont(name: "Avenir-Black", size: 20)
        return label
    }()
    
    let addTagBtn: UIButton = {
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.backgroundColor = .brandColor
        button.titleLabel?.font = UIFont(name: "Apple SD Gothic Neo", size: 16)
        return button
    }()
    
    let addStatusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 13)
        return label
    }()
    
    let dismissBtn: UIButton = {
        let button = UIButton()
        button.setTitle("dismiss", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont(name: "Apple SD Gothic Neo", size: 16)
        return button
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "키워드를 입력해주세요."
        textField.font = UIFont(name: "Apple SD Gothic Neo", size: 16)
        return textField
    }()
    
    override func render() {
        setTextField()

        self.addSubviews(
            dismissBtn,
            titleLabel,
            textField,
            addStatusLabel,
            addTagBtn
        )
        
        dismissBtn.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(40)
            $0.width.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.centerX.equalToSuperview()
        }
        
        textField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(35)
            $0.leading.equalToSuperview().offset(41)
            $0.trailing.equalToSuperview().offset(-47)
        }
        
        addStatusLabel.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(5)
            $0.leading.equalTo(textField.snp.leading)
        }
        
        addTagBtn.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(50)
            $0.leading.equalTo(textField.snp.leading)
            $0.trailing.equalTo(textField.snp.trailing)
        }
    }
        
    func setTextField(){
        textField.autocapitalizationType = .none
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.clearButtonMode = .always
    }
}
