//
//  StorageTableCell.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/04.
//

import UIKit

import SnapKit
import Kingfisher

final class StorageTableViewCell: BaseTableViewCell {
    
    static let identifier = "StorageTableViewCell"
    
    var deleteButtonTappedClosure: ((String) -> Void)?
    
    var url = String()
    let imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    let listText: UILabel = {
        let label = UILabel()
        label.numberOfLines = 5
        label.textColor = UIColor.darkGray
        label.font = UIFont(name: "Avenir-Black", size: 12)
        return label
    }()
    let listTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.tintColor = .black
        label.font = UIFont(name: "Avenir-Black", size: 15)
        return label
    }()
    let date: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Black", size: 10)
        return label
    }()
    let listWriter: UILabel = {
        let label = UILabel()
        label.tintColor = .black
        label.font = UIFont(name: "Avenir-Black", size: 12)
        return label
    }()
    lazy var deleteButton : UIButton = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Black", size: 13)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    override func render() {
        self.contentView.addSubviews(
            imgView,
            date,
            listWriter,
            listTitle,
            listText,
            deleteButton
        )
        
        deleteButton.snp.makeConstraints {
            $0.height.width.equalTo(32)
            $0.bottom.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(15)
        }
        contentView.bringSubviewToFront(deleteButton)

        imgView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        listTitle.snp.makeConstraints {
            $0.top.equalTo(imgView.snp.bottom).offset(15)
            $0.height.equalTo(45)
            $0.leading.trailing.equalToSuperview().inset(15)
        }
        
        listText.snp.makeConstraints {
            $0.top.equalTo(listTitle.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(60)
        }
        
        listWriter.snp.makeConstraints {
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
    
    @objc
    private func buttonTapped(_ sender: UIButton) {
        deleteButtonTappedClosure?(url)
    }
}

extension StorageTableViewCell {
    public func binding(model: StoragePost){
        listTitle.text = model.title
        listWriter.text = model.name
        url = model.url ?? String()
        listText.text = model.summary
        
        if listText.text == TextLiterals.noneText {
            listText.isHidden = true
        }
        
        if let image = model.img {
            if image == TextLiterals.noneText {
                imgView.isHidden = true
                listTitle.snp.remakeConstraints {
                    $0.top.equalToSuperview()
                    $0.height.equalTo(45)
                    $0.leading.trailing.equalToSuperview().inset(15)
                }
            } else {
                let url = URL(string: image)
                imgView.kf.setImage(with: url)
            }
        }
    }

    override func prepareForReuse() {
        imgView.isHidden = false
        listText.isHidden = false
        listTitle.snp.remakeConstraints {
            $0.top.equalTo(imgView.snp.bottom).offset(15)
            $0.height.equalTo(45)
            $0.leading.trailing.equalToSuperview().inset(15)
        }
    }
}
