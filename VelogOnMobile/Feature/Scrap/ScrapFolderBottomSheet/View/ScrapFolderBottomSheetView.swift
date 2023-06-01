//
//  ScrapFolderBottomSheetView.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/28.
//

import UIKit

import SnapKit

final class ScrapFolderBottomSheetView: BaseUIView {

    // MARK: - UI Components
    
    private let bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiterals.bottomSheetText
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont(name: "Avenir-Black", size: 18)
        return label
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .darkGrayColor
        return button
    }()
    
    let newFolderButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.plusFolder, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        return button
    }()
    
    private let folderTitleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiterals
            .makeNewFolderButtonText
        label.textColor = .black
        label.font = UIFont(name: "Avenir-Black", size: 15)
        return label
    }()
    
    let folderTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(cell: ScrapFolderBottomSheetTableViewCell.self)
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 46
        tableView.sectionHeaderHeight = 0
        return tableView
    }()
    
    // MARK: - Functions
    
    override func configUI() {
        self.backgroundColor = .white
    }
    
    override func render() {
        self.addSubviews(bottomSheetView)
        bottomSheetView.addSubviews(
            titleLabel,
            cancelButton,
            newFolderButton,
            folderTitleLabel,
            folderTableView
        )
        
        bottomSheetView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(SizeLiterals.screenHeight / 2)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.centerX.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints {
            $0.size.equalTo(16)
            $0.top.trailing.equalToSuperview().inset(18)
        }
        
        newFolderButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.leading.equalToSuperview().inset(20)
            $0.height.width.equalTo(26)
        }
        
        folderTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(newFolderButton)
            $0.leading.equalTo(newFolderButton.snp.trailing).offset(10)
        }
    
        folderTableView.snp.makeConstraints {
            $0.top.equalTo(newFolderButton.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
