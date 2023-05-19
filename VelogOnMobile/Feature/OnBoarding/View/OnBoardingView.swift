//
//  OnBoardingView.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/11.
//

import UIKit

final class OnBoardingView: BaseUIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose Keyword"
        label.font = UIFont(name: "Avenir-Black", size: 30)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "추가한 키워드와 관련된 글을 볼 수 있습니다."
        label.font = UIFont(name: "Avenir-Black", size: 15)
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .brandColor
        button.layer.cornerRadius = 4
        button.setTitle("시작", for: .normal)
        return button
    }()
}

