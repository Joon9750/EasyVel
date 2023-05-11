//
//  KeywordsTableViewCell.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/30.
//

import UIKit

import SnapKit
import Kingfisher

final class KeywordsTableViewCell: BaseTableViewCell {
    
    static let identifier = "KeywordsTableViewCell"
    
    var url = String()
    let imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    let textView: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor.darkGray
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.font = UIFont(name: "Avenir-Black", size: 12)
        return textView
    }()
    let title: UILabel = {
        let title = UILabel()
        title.font = UIFont(name: "Avenir-Black", size: 17)
        return title
    }()
    let date: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Black", size: 10)
        return label
    }()
    let name: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Black", size: 12)
        return label
    }()
    let tagFristButton: PostTagUIButton = PostTagUIButton()
    let tagSecondButton: PostTagUIButton = PostTagUIButton()
    let tagThirdButton: PostTagUIButton = PostTagUIButton()
    let tagFourthButton: PostTagUIButton = PostTagUIButton()
    let tagFifthButton: PostTagUIButton = PostTagUIButton()
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 6
        stackView.axis = .horizontal
        return stackView
    }()
    
    // MARK: - life cycle
    
    override func render() {
        self.addSubviews(
            buttonStackView,
            imgView,
            date,
            name,
            title,
            textView
        )
        
        buttonStackView.addArrangedSubviews(
            tagFristButton,
            tagSecondButton,
            tagThirdButton,
            tagFourthButton,
            tagFifthButton
        )
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(12)
        }
        self.bringSubviewToFront(buttonStackView)
        
        imgView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        title.snp.makeConstraints {
            $0.top.equalTo(imgView.snp.bottom).offset(15)
            $0.height.equalTo(45)
            $0.leading.trailing.equalToSuperview().inset(15)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(60)
        }
        
        name.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(15)
            $0.width.equalTo(120)
            $0.leading.equalToSuperview().inset(15)
        }
        
        date.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(15)
            $0.trailing.equalToSuperview().inset(15)
        }
    }
    
    private func tagFristButtonIsNotHidden(buttonTitle: String) {
        tagFristButton.isHidden = false
        tagFristButton.setTitle(buttonTitle, for: .normal)
    }
    
    private func tagSecondButtonIsNotHidden(buttonTitle: String) {
        tagSecondButton.isHidden = false
        tagSecondButton.setTitle(buttonTitle, for: .normal)
    }
    
    private func tagThirdButtonIsNotHidden(buttonTitle: String) {
        tagThirdButton.isHidden = false
        tagThirdButton.setTitle(buttonTitle, for: .normal)
    }
    
    private func tagFourthButtonIsNotHidden(buttonTitle: String) {
        tagFourthButton.isHidden = false
        tagFourthButton.setTitle(buttonTitle, for: .normal)
    }
    
    private func tagFifthButtonIsNotHidden(buttonTitle: String) {
        tagFifthButton.isHidden = false
        tagFifthButton.setTitle(buttonTitle, for: .normal)
    }
}

extension KeywordsTableViewCell {
    public func binding(model: TagPostDtoList){
        title.text = model.title
        name.text = model.name
        date.text = model.date
        url = model.url ?? String()
        textView.text = model.summary
        
        if let image = model.img {
            if image == TextLiterals.noneText {
                imgView.isHidden = true
                title.snp.remakeConstraints {
                    $0.top.equalTo(buttonStackView.snp.bottom).offset(15)
                    $0.height.equalTo(45)
                    $0.leading.trailing.equalToSuperview().inset(15)
                }
            } else {
                let url = URL(string: image)
                imgView.kf.setImage(with: url)
            }
        }
        
        guard let tagList = model.tag else { return }
        switch model.tag?.count {
        case 0: break
        case 1:
            tagFristButtonIsNotHidden(buttonTitle: tagList[0])
        case 2:
            tagFristButtonIsNotHidden(buttonTitle: tagList[0])
            tagSecondButtonIsNotHidden(buttonTitle: tagList[1])
        case 3:
            tagFristButtonIsNotHidden(buttonTitle: tagList[0])
            tagSecondButtonIsNotHidden(buttonTitle: tagList[1])
            tagThirdButtonIsNotHidden(buttonTitle: tagList[2])
        case 4:
            tagFristButtonIsNotHidden(buttonTitle: tagList[0])
            tagSecondButtonIsNotHidden(buttonTitle: tagList[1])
            tagThirdButtonIsNotHidden(buttonTitle: tagList[2])
            tagFourthButtonIsNotHidden(buttonTitle: tagList[3])
        case 5:
            tagFristButtonIsNotHidden(buttonTitle: tagList[0])
            tagSecondButtonIsNotHidden(buttonTitle: tagList[1])
            tagThirdButtonIsNotHidden(buttonTitle: tagList[2])
            tagFourthButtonIsNotHidden(buttonTitle: tagList[3])
            tagFifthButtonIsNotHidden(buttonTitle: tagList[4])
        default:
            tagFristButtonIsNotHidden(buttonTitle: tagList[0])
            tagSecondButtonIsNotHidden(buttonTitle: tagList[1])
            tagThirdButtonIsNotHidden(buttonTitle: tagList[2])
            tagFourthButtonIsNotHidden(buttonTitle: tagList[3])
            tagFifthButtonIsNotHidden(buttonTitle: tagList[4])
        }
    }
    
    override func prepareForReuse() {
        imgView.isHidden = false
        title.snp.remakeConstraints {
            $0.top.equalTo(imgView.snp.bottom).offset(15)
            $0.height.equalTo(45)
            $0.leading.trailing.equalToSuperview().inset(15)
        }
    }
}
