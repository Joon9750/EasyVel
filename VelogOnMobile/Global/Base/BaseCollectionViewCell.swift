//
//  BaseCollectionViewCell.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func render() {}
    
    func configUI() {}
}
