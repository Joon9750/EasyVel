//
//  FolderHeaderView.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/28.
//

import UIKit

import SnapKit

final class ScrapFolderHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Properties
    
    static var identifier: String = "FolderHeaderView"
    
    // MARK: - UI Components
    
    private lazy var newFolderButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.plusFolder, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        return button
    }()
    
    private let folderTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "새 폴더 만들기"
        label.textColor = .black
        label.font = UIFont(name: "Avenir-Black", size: 15)
        return label
    }()
    
    // MARK: - Life Cycles
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        contentView.addSubviews(
            newFolderButton,
            folderTitleLabel
        )
        
        newFolderButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(40)
        }
        
        folderTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(newFolderButton.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
        }
    }
}
