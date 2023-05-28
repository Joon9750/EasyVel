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
        view.roundCorners(cornerRadius: 8,
                          maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "폴더 선택"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont(name: "Avenir-Black", size: 18)
        return label
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        return button
    }()
    
    let folderTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(cell: ScrapFolderBottomSheetTableViewCell.self)
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 46
        tableView.sectionHeaderHeight = 49
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
            folderTableView
        )
        
        bottomSheetView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(SizeLiterals.screenHeight / 2)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.centerX.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints {
            $0.size.equalTo(16)
            $0.top.trailing.equalToSuperview().inset(18)
        }
        
        folderTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
