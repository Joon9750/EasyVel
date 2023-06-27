//
//  HomeMenuCollectionViewCell.swift
//  VelogOnMobile
//
//  Created by 장석우 on 2023/06/27.
//

import UIKit

import SnapKit

final class HomeMenuCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    enum MenuType: String, CaseIterable {
        case plus = ""
        case trend = "트렌드"
        case follow = "팔로우"
        case tag
        
        var isText: Bool {
            switch self {
            case .plus:
                return false
            default:
                return true
            }
        }
    }
    
    private var menuType: MenuType = .plus {
        didSet{
            updateUI()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? .gray700 : .gray300
            titleLabel.font = isSelected ? .body_2_B : .body_2_M
        }
    }
    
    private var keyword: String?
    
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
        
        style()
        hierarchy()
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    //MARK: - Custom Method
    
    func dataBind(_ type: MenuType, keyword: String?) {
        self.keyword = keyword
        self.menuType = type
    }
}

private extension HomeMenuCollectionViewCell {
    
    func style() {
        contentView.backgroundColor = .white
        plusImageView.isHidden = true
    }
    
    func hierarchy() {
        contentView.addSubviews(titleLabel, plusImageView)
    }
    
    func layout() {
        titleLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(15)
        }
        
        plusImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(16)
        }
    }
    
    func updateUI() {
        plusImageView.isHidden = menuType.isText
        titleLabel.isHidden = !menuType.isText
        
        switch menuType {
        case .plus: return
        case .trend, .follow:
            titleLabel.text = menuType.rawValue
        case .tag:
            titleLabel.text = keyword
        }
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


