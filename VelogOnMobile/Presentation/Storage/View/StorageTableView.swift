//
//  StorageTableView.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/04.
//

import UIKit

import SnapKit

final class StorageTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupTableView() {
        register(StorageTableViewCell.self, forCellReuseIdentifier:
                    StorageTableViewCell.identifier)
        separatorStyle = .singleLine
        showsVerticalScrollIndicator = true
    }
}
