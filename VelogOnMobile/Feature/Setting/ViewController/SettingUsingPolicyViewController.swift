//
//  SettingUsePolicyViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/07/11.
//

import UIKit

import SnapKit

final class SettingUsingPolicyViewController: BaseViewController {

    // MARK: - property
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let contentLabel: UILabel = {
       let label = UILabel()
        label.text = TextLiterals.usingPolicyText
        label.textColor = .gray700
        label.font = .caption_1_M
        label.numberOfLines = 0
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - life cycle
    
    override func render() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(contentLabel)
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.width.edges.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
