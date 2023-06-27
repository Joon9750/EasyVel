////
////  HomeMenuCollectionViewCell.swift
////  VelogOnMobile
////
////  Created by 장석우 on 2023/06/02.
////
//
//import UIKit
//
//import SnapKit
//
//final class HomeMenuKeywordCollectionViewCell: UICollectionViewCell {
//    
//    //MARK: - Properties
//    
//    override var isSelected: Bool {
//        didSet {
//            titleLabel.textColor = isSelected ? .gray700 : .gray300
//            titleLabel.font = isSelected ? .body_2_B : .body_2_M
//        }
//    }
//    
//    var title: String? {
//        didSet {
//            titleLabel.text = title
//        }
//    }
//    
//    //MARK: - UI Components
//    
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .gray300
//        label.font = .body_2_M
//        return label
//    }()
//    
//    //MARK: - Life Cycle
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        contentView.backgroundColor = .white
//        contentView.addSubviews(titleLabel)
//        
//        titleLabel.snp.makeConstraints {
//            $0.verticalEdges.equalToSuperview()
//            $0.horizontalEdges.equalToSuperview().inset(15)
//        }
//    }
//    
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//    }
//    
//    //MARK: - Custom Method
//    
//    func dataBind(tag: String) {
//        self.title = tag
//    }
//}
//
//extension HomeMenuKeywordCollectionViewCell {
//    
//    func sizeFittingWith(cellHeight: CGFloat) -> CGSize {
//        titleLabel.font = .body_2_B
//        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: cellHeight)
//        return self.contentView.systemLayoutSizeFitting(targetSize,
//                                                        withHorizontalFittingPriority: .fittingSizeLevel,
//                                                        verticalFittingPriority: .required)
//    }
//}
