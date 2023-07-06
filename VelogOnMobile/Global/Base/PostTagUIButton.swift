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
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.makeRounded(ratio: 2)
    }
    
    func setupButton() {
        self.backgroundColor = .brandColor
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = .caption_1_M
        self.contentEdgeInsets = UIEdgeInsets(top: 2, left: 12, bottom: 2, right: 12)
        self.isHidden = true
    }
}
