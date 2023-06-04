//
//  HomePostViewController.swift
//  VelogOnMobile
//
//  Created by 장석우 on 2023/06/03.
//

import UIKit

import SnapKit

final class PostsViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: PostsViewModel
    
    //MARK: - UI Components
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(cell: PostTableViewCell.self)
        tableView.showsVerticalScrollIndicator = true
        return tableView
    }()
    
    //MARK: - Life Cycle
    
    init(viewModel: PostsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate()
        bind()
        style()
        hierarchy()
        layout()
    }
    
    //MARK: - Custom Method
    
    private func delegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func bind() {
        <#code#>
    }
    
    
    private func style() {
        
    }
    
    private func hierarchy() {
        
    }
    
    private func layout() {
        
    }
    
    //MARK: - Action Method
    
}

//MARK: - UITableViewDataSource

extension PostsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.pos
        return
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
}

//MARK: - UITableViewDelegate

extension PostsViewController: UITableViewDelegate {
    
}
