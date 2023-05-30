//
//  ScrapFolderBottomSheetTableViewCell.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/28.
//

import UIKit

import SnapKit

final class ScrapFolderBottomSheetTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    static var identifier: String = "ScrapFolderBottomSheetTableViewCell"
    
    // MARK: - UI Components

    private let folderTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Avenir-Black", size: 15)
        return label
    }()
    
    // MARK: - Life Cycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        contentView.addSubview(folderTitleLabel)

        folderTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
    }
    
    func bind(text: String) {
        folderTitleLabel.text = text
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.folderTitleLabel.text = TextLiterals.noneText
    }
    
    public func configure(folderList: String) {
        updateTable(with: folderList)
    }
    
    private func updateTable(with folderList: String) {
        folderTitleLabel.text = folderList
    }
}
