//
//  PopularTagTableViewCell.swift
//  VelogOnMobile
//
//  Created by 장석우 on 2023/06/30.
//

import UIKit

import SnapKit

final class PopularTagTableViewCell: BaseTableViewCell {
    
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
    
    func updateUI(index: Int, tag: String) {
        let rank = index + 1
        rankLabel.text = String(rank)
        tagLabel.text = tag
        
        updateRankLabelUI(rank: rank)
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
    
    func updateRankLabelUI(rank: Int) {
        switch rank {
        case 1...3:
            rankLabel.textColor = .brandColor
        default:
            rankLabel.textColor = .gray700
        }
        
        
    }
    
}



