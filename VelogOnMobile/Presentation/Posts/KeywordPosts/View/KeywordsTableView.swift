//
//  KeywordsTableView.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/30.
//

import UIKit

import SnapKit

final class KeywordsTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupTableView() {
        register(KeywordsTableViewCell.self, forCellReuseIdentifier: KeywordsTableViewCell.identifier)
        dataSource = self
        delegate = self
        separatorStyle = .singleLine
        showsVerticalScrollIndicator = true
    }
}

extension KeywordsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell touched")
    }
}

extension KeywordsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // PostData.Post.subscribePostDtoList.count
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KeywordsTableViewCell.identifier, for: indexPath) as? KeywordsTableViewCell ?? KeywordsTableViewCell()
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
}
