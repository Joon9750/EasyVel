//
//  ListTableView.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/30.
//

import UIKit

import SnapKit

final class ListTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupTableView() {
        register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        separatorStyle = .singleLine
        showsVerticalScrollIndicator = true
        isHidden = true
    }
}
