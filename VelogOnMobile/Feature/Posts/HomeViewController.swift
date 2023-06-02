//
//  PostsViewController.swift
//  VelogOnMobile
//
//  Created by 장석우 on 2023/06/02.
//

import UIKit

import SnapKit

final class HomeViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let navigationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiterals.homeViewControllerTitle
        label.font = .avenir(ofSize: 26)
        return label
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.searchIcon, for: .normal)
        return button
    }()
    
    private let homeMenuBar = HomeMenuBar()
    
    
    //MARK: - UI Components
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate()
        style()
        hierarchy()
        layout()
    }
    
    //MARK: - Custom Method
    
    private func delegate() {
        homeMenuBar.delegate = self
    }
    
    private func style() {
        view.backgroundColor = .systemGray2
    }
    
    private func hierarchy() {
        view.addSubviews(navigationView, homeMenuBar)
        
        navigationView.addSubviews(titleLabel, searchButton)
        
    }
    
    private func layout() {
        navigationView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(122)
        }
        
        homeMenuBar.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(80)
            $0.leading.equalToSuperview().inset(17)
        }
        
        searchButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(54)
            $0.trailing.equalToSuperview().inset(24)
            $0.size.equalTo(20)
        }
    }
    
    //MARK: - Action Method
    
}

extension HomeViewController: MenuItemDelegate {
    func menuView(didSelectItemAt indexPath: IndexPath) {
        homeMenuBar.isSelected = indexPath.row
    }
    
    
}
