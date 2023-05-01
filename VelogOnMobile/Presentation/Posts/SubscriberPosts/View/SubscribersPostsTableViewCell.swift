//
//  PostsTableViewCell.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//

import UIKit

import SnapKit

final class SubscribersPostsTableViewCell: BaseTableViewCell {

    static let identifier = "SubscribersPostsTableViewCell"
    
    let imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.image = ImageLiterals.dummyImage
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
        textView.text = "자~~ 리팩토링 해보자!!!\n자~~ 리팩토링 해보자!!!\n자~~ 리팩토링 해보자!!!\n자~~ 리팩토링 해보자!!!"
        return textView
    }()
    
    let title: UILabel = {
        let title = UILabel()
        title.font = UIFont(name: "Avenir-Black", size: 15)
        title.text = "Velog On Mobile"
        return title
    }()
    
    let date: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "2023-03-01"
        return label
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Black", size: 13)
        label.text = "홍준혁"
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
            $0.leading.equalTo(name)
        }

        textView.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }
    }
}
