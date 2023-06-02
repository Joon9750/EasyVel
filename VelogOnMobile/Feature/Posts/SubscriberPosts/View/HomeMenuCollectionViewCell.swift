//
//  HomeMenuCollectionViewCell.swift
//  VelogOnMobile
//
//  Created by 장석우 on 2023/06/02.
//

import UIKit

import SnapKit

class HomeMenuCollectionViewCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? .black : .gray
        }
    }
    
    static var cellId = "HomeMenuCollectionViewCell"
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .avenir(ofSize: 16)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(15)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

extension HomeMenuCollectionViewCell {
    func sizeFittingWith(cellHeight: CGFloat) -> CGSize {
        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: cellHeight)
        return self.contentView.systemLayoutSizeFitting(targetSize,
                                                        withHorizontalFittingPriority: .fittingSizeLevel,
                                                        verticalFittingPriority: .required)
    }
}

