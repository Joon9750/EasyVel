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
    
    var url = String()
    let listTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.tintColor = .black
        label.font = UIFont(name: "Avenir-Black", size: 15)
        return label
    }()
    
    let listText: UILabel = {
        let label = UILabel()
        label.numberOfLines = 5
        label.textColor = UIColor.darkGray
        label.font = UIFont(name: "Avenir-Black", size: 12)
        return label
    }()
    
    let listWriter: UILabel = {
        let label = UILabel()
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
            $0.top.equalToSuperview().offset(20)
            $0.height.equalTo(20)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        listWriter.snp.makeConstraints {
            $0.top.equalTo(listTitle.snp.bottom).offset(5)
            $0.height.equalTo(15)
            $0.leading.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(140)
        }
        
        listText.snp.makeConstraints {
            $0.top.equalTo(listWriter.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(140)
        }
        
        imgView.snp.makeConstraints {
            $0.top.equalTo(listTitle.snp.bottom).offset(5)
            $0.leading.equalTo(listText.snp.trailing).offset(5)
            $0.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(20)
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
                listText.snp.updateConstraints {
                    $0.trailing.equalToSuperview().inset(10)
                }
                imgView.snp.remakeConstraints {
                    $0.width.height.equalTo(0)
                }
            } else {
                let url = URL(string: image)
                imgView.kf.setImage(with: url)
            }
        }
    }
    
    override func prepareForReuse() {
        listText.snp.updateConstraints {
            $0.trailing.equalToSuperview().inset(140)
        }
        
        imgView.snp.remakeConstraints {
            $0.top.equalTo(listTitle.snp.bottom).offset(10)
            $0.leading.equalTo(listText.snp.trailing).offset(5)
            $0.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}
