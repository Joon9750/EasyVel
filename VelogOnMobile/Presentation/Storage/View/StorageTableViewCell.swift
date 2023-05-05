//
//  StorageTableCell.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/04.
//

import UIKit

import SnapKit

final class StorageTableViewCell: BaseTableViewCell {
    
    static let identifier = "StorageTableViewCell"
    
    var url = String()
    let listTitle: UILabel = {
        let label = UILabel()
        label.text = "MVVM"
        label.numberOfLines = 2
        label.tintColor = .black
        label.font = UIFont(name: "Avenir-Black", size: 15)
        return label
    }()
    
    let listText: UILabel = {
        let label = UILabel()
        label.text = "MVVM 해보고 싶다..MVVM 해보고 싶다..MVVM 해보고 싶다..MVVM 해보고 싶다..MVVM 해보고 싶다..MVVM 해보고 싶다..MVVM 해보고 싶다..MVVM 해보고 싶다.."
        label.numberOfLines = 5
        label.textColor = UIColor.darkGray
        label.font = UIFont(name: "Avenir-Black", size: 12)
        return label
    }()
    
    let listWriter: UILabel = {
        let label = UILabel()
        label.text = "홍준혁"
        label.tintColor = .black
        label.font = UIFont(name: "Avenir-Black", size: 12)
        return label
    }()
    
    let imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func render() {
        self.addSubviews(
            listTitle,
            listText,
            listWriter,
            imgView
        )
        
        listTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(120)
        }
        
        listWriter.snp.makeConstraints {
            $0.top.equalTo(listTitle.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(120)
        }
        
        listText.snp.makeConstraints {
            $0.top.equalTo(listWriter.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(120)
        }
        
        imgView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalTo(listTitle.snp.trailing).offset(5)
            $0.trailing.equalToSuperview().inset(5)
            $0.bottom.equalTo(listText.snp.bottom)
        }
    }
}

extension StorageTableViewCell {
    public func binding(model: StoragePost){
        listTitle.text = model.title
        listWriter.text = model.name
        url = model.url ?? String()
        listText.text = model.summary
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
