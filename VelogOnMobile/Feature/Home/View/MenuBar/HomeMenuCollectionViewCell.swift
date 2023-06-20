//
//  HomeMenuCollectionViewCell.swift
//  VelogOnMobile
//
//  Created by 장석우 on 2023/06/02.
//

import UIKit

import SnapKit

final class HomeMenuCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? .gray700 : .gray300
            titleLabel.font = isSelected ? .body_2_B : .body_2_M
        }
    }
    
    static var cellId = "HomeMenuCollectionViewCell"
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    //MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray300
        label.font = .body_2_M
        return label
    }()
    
    private let plusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.plusIcon
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        contentView.addSubviews(titleLabel, plusImageView)
        
        titleLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(15)
        }
        
        plusImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(16)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    //MARK: - Custom Method
    
    func dataBind(tag: String) {
        titleLabel.isHidden = false
        plusImageView.isHidden = true
        
        self.title = tag
    }
    
    func setPlusMenu() {
        titleLabel.isHidden = true
        plusImageView.isHidden = false   
    }
}

extension HomeMenuCollectionViewCell {
    
    func sizeFittingWith(cellHeight: CGFloat) -> CGSize {
        titleLabel.font = .body_2_B
        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: cellHeight)
        return self.contentView.systemLayoutSizeFitting(targetSize,
                                                        withHorizontalFittingPriority: .fittingSizeLevel,
                                                        verticalFittingPriority: .required)
    }
}
