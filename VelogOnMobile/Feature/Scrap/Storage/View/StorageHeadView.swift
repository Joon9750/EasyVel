//
//  StorageHeadView.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/04.
//

import UIKit

import SnapKit

final class StorageHeadView: BaseUIView {
    
    var titleLabelWidth: CGFloat?
    
    // MARK: - property
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Black", size: 16)
        return label
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let pointLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .brandColor
        return view
    }()
    
    let deleteFolderButton : UIButton = {
        let button = UIButton()
        button.setTitle("폴더 삭제", for: .normal)
        button.setTitleColor(UIColor.textGrayColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Black", size: 15)
        button.backgroundColor = .white
        return button
    }()
    
    override func render() {
        self.addSubviews(
            titleLabel,
            lineView,
            pointLineView,
            deleteFolderButton
        )
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(132)
            $0.leading.equalToSuperview().offset(20)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
        }
        
        pointLineView.snp.makeConstraints {
            $0.centerY.equalTo(lineView)
            $0.height.equalTo(3)
            $0.width.equalTo(121)
            $0.leading.equalToSuperview().offset(12)
        }
        
        deleteFolderButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    override func configUI() {
        self.backgroundColor = .white
    }
}
