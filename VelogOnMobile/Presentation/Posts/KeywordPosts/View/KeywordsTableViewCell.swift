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

    // MARK: - life cycle
    
    override func render() {
        self.addSubviews(
            imgView,
            date,
            name,
            title,
            textView
        )
        
        title.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.height.equalTo(20)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        name.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(5)
            $0.height.equalTo(15)
            $0.width.equalTo(120)
            $0.leading.equalToSuperview().inset(10)
        }

        textView.snp.makeConstraints {
            $0.top.equalTo(name.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(140)
        }
        
        date.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(5)
            $0.height.equalTo(15)
            $0.trailing.equalToSuperview().inset(10)
        }

        imgView.snp.makeConstraints {
            $0.top.equalTo(name.snp.bottom).offset(10)
            $0.leading.equalTo(textView.snp.trailing).offset(5)
            $0.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(20)
        }
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
            if image == "" {
                textView.snp.updateConstraints {
                    $0.trailing.equalToSuperview().inset(10)
                }
                imgView.isHidden = true
            } else {
                let url = URL(string: image)
                imgView.kf.setImage(with: url)
            }
        }
    }
}
