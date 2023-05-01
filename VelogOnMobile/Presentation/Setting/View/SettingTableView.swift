//
//  SettingTableView.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/01.
//

import UIKit

final class SettingTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupTableView() {
        register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.cellId)
        dataSource = self
        delegate = self
        separatorStyle = .singleLine
        showsVerticalScrollIndicator = false
        backgroundColor = .white
        isScrollEnabled = false
    }
}

extension SettingTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: print("로그아웃")
        case 1: print("회원탈퇴")
        case 2: print("이메일 변경")
        case 3: print("비밀번호 변경")
        default: return
        }
    }
}

extension SettingTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: SettingTableViewCell.cellId, for: indexPath) as! SettingTableViewCell
        cell.selectionStyle = .none
        let row = indexPath.row
        switch row {
        case 0: cell.buttonLabel.text = "로그아웃"
        case 1: cell.buttonLabel.text = "회원탈퇴"
        case 2: cell.buttonLabel.text = "이메일 변경"
        case 3: cell.buttonLabel.text = "비밀번호 변경"
        default: return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}