//
//  HomePostViewController.swift
//  VelogOnMobile
//
//  Created by 장석우 on 2023/06/03.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class PostsViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewModel: PostsViewModel
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(cell: PostTableViewCell.self)
        tableView.showsVerticalScrollIndicator = true
        tableView.rowHeight = SizeLiterals.postCellXLarge
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGray6
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
        
        bind()
        hierarchy()
        layout()
    }
    
    //MARK: - Bind
    
    private func bind() {
        let input = PostsViewModel.Input(
            viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in },
            scrollReachedBottomEvent: .never(),
            postCellDidTapEvent: tableView.rx.itemSelected.map { $0.row },
            scrapButtonDidTapEvent: .never()
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        self.bindOutput(output: output)
    }
    
    private func bindOutput(output: PostsViewModel.Output ) {
        output.post
            .asDriver(onErrorDriveWith: .never())
            .drive(onNext: { viewModel in
                //TODO: 해당 역할을 Coordinator에게 맡기자. Coordinator는 VM이 소유하고 있어야 하나?
                let webViewController = WebViewController(viewModel: viewModel)
                self.navigationController?.pushViewController(webViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.posts
            .asDriver()
            .drive(
                self.tableView.rx.items(cellIdentifier: PostTableViewCell.reuseIdentifier,
                                        cellType: PostTableViewCell.self)
            ) { _, model, cell in
                cell.binding(model: model)
            }
            .disposed(by: disposeBag)
        
        
    }
   
    
    //MARK: - Action Method
    
}

extension PostsViewController {
    
    private func hierarchy() {
        view.addSubview(tableView)
    }
    
    private func layout() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

