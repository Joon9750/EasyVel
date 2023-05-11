//
//  PostTagUIButton.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/11.
//

import UIKit

import SnapKit

class PostTagUIButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupButton() {
        self.backgroundColor = .brandColor
        self.setTitleColor(.white, for: .normal)
        self.layer.cornerRadius = 5
        self.setTitle("iOS", for: .normal)
        self.titleLabel?.font = UIFont(name: "Avenir-Black", size: 12)
        self.alpha = 0.7
        self.contentEdgeInsets = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
        self.isHidden = true
    }
}
