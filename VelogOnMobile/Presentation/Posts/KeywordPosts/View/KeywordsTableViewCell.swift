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
        textView.font = UIFont.systemFont(ofSize: 15)
        return textView
    }()
    
    let title: UILabel = {
        let title = UILabel()
        title.font = UIFont(name: "Avenir-Black", size: 15)
        return title
    }()
    
    let date: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Black", size: 13)
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

        imgView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(150)
        }
        
        name.snp.makeConstraints {
            $0.top.equalTo(imgView.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(20)
        }
        
        date.snp.makeConstraints {
            $0.top.equalTo(imgView.snp.bottom).offset(5)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        title.snp.makeConstraints {
            $0.top.equalTo(name.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        textView.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
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
                imgView.image = UIImage(systemName: "photo.on.rectangle.angled")?.withTintColor(.gray)
            } else {
                let url = URL(string: image)
                imgView.kf.setImage(with: url)
            }
        }
    }
}
