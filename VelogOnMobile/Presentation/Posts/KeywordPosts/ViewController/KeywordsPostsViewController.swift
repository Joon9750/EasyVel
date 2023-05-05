//
//  KeywordsPostsViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/30.
//

import UIKit

final class KeywordsPostsViewController: BaseViewController {
    
    private let keywordsPostsView = KeywordsPostsView()
    private var viewModel: KeywordsPostsViewModelInputOutput?
    private var keywordsPosts: GetTagPostResponse? {
        didSet {
            keywordsPostsView.keywordsTableView.reloadData()
        }
    }
    
    init(viewModel: KeywordsPostsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func render() {
        self.view = keywordsPostsView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.viewWillAppear()
    }
    
    private func bind() {
        keywordsPostsView.keywordsTableView.dataSource = self
        keywordsPostsView.keywordsTableView.delegate = self
        viewModel?.tagPostsListOutput = { [weak self] postsResult in
            self?.keywordsPosts = postsResult
        }
    }
}

extension KeywordsPostsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return keywordsPosts?.tagPostDtoList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KeywordsTableViewCell.identifier, for: indexPath) as? KeywordsTableViewCell ?? KeywordsTableViewCell()
        cell.selectionStyle = .none
        let index = indexPath.section
        if let data = keywordsPosts?.tagPostDtoList?[index] {
            cell.binding(model: data)
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
}

extension KeywordsPostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! KeywordsTableViewCell
        let index = indexPath.section
        let post = StoragePost(
            img: keywordsPosts?.tagPostDtoList?[index].img,
            name: keywordsPosts?.tagPostDtoList?[index].name,
            summary: keywordsPosts?.tagPostDtoList?[index].summary,
            title: keywordsPosts?.tagPostDtoList?[index].title,
            url: keywordsPosts?.tagPostDtoList?[index].url
        )
        
        // MARK: - fix me
        viewModel?.cellDidTap(input: post)
        let url = selectedCell.url
        let webViewController = WebViewController(url: url)
        navigationController?.pushViewController(webViewController, animated: true)
    }
}
