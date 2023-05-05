//
//  SubscribePostsViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//

import UIKit

final class SubscribePostsViewController: BaseViewController {

    private let subscribersPostsView = SubscribersPostsView()
    private var viewModel: SubscriberPostsViewModelInputOutput?
    private var subscriberPosts: GetSubscriberPostResponse? {
        didSet {
            subscribersPostsView.postTableView.reloadData()
        }
    }
    
    init(viewModel: SubscriberPostsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func render() {
        self.view = subscribersPostsView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.viewWillAppear()
    }
    
    private func bind() {
        subscribersPostsView.postTableView.dataSource = self
        subscribersPostsView.postTableView.delegate = self
        viewModel?.subscriberPostsListOutput = { [weak self] postsResult in
            self?.subscriberPosts = postsResult
        }
    }
}

extension SubscribePostsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return subscriberPosts?.subscribePostDtoList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubscribersPostsTableViewCell.identifier, for: indexPath) as? SubscribersPostsTableViewCell ?? SubscribersPostsTableViewCell()
        cell.selectionStyle = .none
        let index = indexPath.section
        if let data = subscriberPosts?.subscribePostDtoList?[index] {
            cell.binding(model: data)
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}

extension SubscribePostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! SubscribersPostsTableViewCell
        let index = indexPath.section
        let post = StoragePost(
            img: subscriberPosts?.subscribePostDtoList?[index].img,
            name: subscriberPosts?.subscribePostDtoList?[index].name,
            summary: subscriberPosts?.subscribePostDtoList?[index].summary,
            title: subscriberPosts?.subscribePostDtoList?[index].title,
            url: subscriberPosts?.subscribePostDtoList?[index].url
        )
        
        // MARK: - fix me
        viewModel?.cellDidTap(input: post)
        let url = selectedCell.url
        let webViewController = WebViewController(url: url)
        navigationController?.pushViewController(webViewController, animated: true)
    }
}
