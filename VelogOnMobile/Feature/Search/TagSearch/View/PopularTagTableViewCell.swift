//
//  PopularTagTableViewCell.swift
//  VelogOnMobile
//
//  Created by 장석우 on 2023/06/30.
//

import UIKit

import SnapKit

final class PopularTagTableViewCell: BaseTableViewCell {
    
    //MARK: - Properties
    
    private var rankData: Int? {
        didSet {
            updateRankLabelUI()
        }
    }
    
    private var tagData: String? {
        didSet {
            tagLabel.text = tagData
        }
    }
    
    //MARK: - UI Components
    
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray700
        label.font = .body_1_B
        return label
    }()
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray700
        label.font = .body_1_M
        return label
    }()
    
    
    //MARK: - Life Cycle

    override func render() {
        selectionStyle = .none
        hierarchy()
        layout()
    }
    
    //MARK: - Public Method
    
    func dataBind(index: Int, data: String) {
        self.rankData = index + 1
        self.tagData = data
    }
}

//MARK: - Private Method

private extension PopularTagTableViewCell {
    
    func hierarchy() {
        
        contentView.addSubviews(rankLabel,
                                tagLabel)
        
    }
    
    func layout() {
        rankLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        tagLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(23)
        }
    }
    
    func updateRankLabelUI() {
        guard let rankData else { return }
        switch rankData {
        case 1...3:
            rankLabel.textColor = .brandColor
        default:
            rankLabel.textColor = .gray700
        }
        
        rankLabel.text = String(rankData)
    }
    
}



