//
//  PostsTableView.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//

import UIKit

import SnapKit

final class PostsTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupTableView() {
        register(SubscribersPostsTableViewCell.self, forCellReuseIdentifier: SubscribersPostsTableViewCell.identifier)
        separatorStyle = .singleLine
        showsVerticalScrollIndicator = true
    }
}
