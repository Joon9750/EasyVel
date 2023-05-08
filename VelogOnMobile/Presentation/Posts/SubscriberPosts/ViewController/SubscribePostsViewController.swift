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
        setButtonAction()
        subscribersPostsView.postTableView.dataSource = self
        subscribersPostsView.postTableView.delegate = self
        viewModel?.subscriberPostsListOutput = { [weak self] postsResult in
            self?.subscriberPosts = postsResult
        }
        viewModel?.toastPresent = { [weak self] result in
            if result {
                self?.showToast(message: TextLiterals.alreadyAddToastText, font: UIFont(name: "Avenir-Black", size: 14) ?? UIFont())
            }
        }
        viewModel?.isPostsEmpty = { [weak self] isEmpty in
            if isEmpty {
                self?.subscribersPostsView.keywordsPostsViewExceptionView.isHidden = false
            } else {
                self?.subscribersPostsView.keywordsPostsViewExceptionView.isHidden = true
            }
        }
    }
    
    private func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0)) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-50, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.brandColor
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 10.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    private func setButtonAction() {
        subscribersPostsView.moveToTopButton.addTarget(self, action: #selector(moveToTop), for: .touchUpInside)
    }
    
    @objc
    func moveToTop() {
        let indexPath = IndexPath(row: 0, section: 0)
        subscribersPostsView.postTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}

extension SubscribePostsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 200 {
            subscribersPostsView.moveToTopButton.isHidden = false
        } else {
            subscribersPostsView.moveToTopButton.isHidden = true
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
        let textNum = subscriberPosts?.subscribePostDtoList?[indexPath.section].summary?.count ?? 0
        if subscriberPosts?.subscribePostDtoList?[indexPath.section].img ?? String() == TextLiterals.noneText {
            switch textNum {
            case 0...50: return SizeLiterals.postCellSmall
            case 51...80: return SizeLiterals.postCellMedium
            case 81...100: return SizeLiterals.postCellLarge
            default: return SizeLiterals.postCellLarge
            }
        } else {
            return SizeLiterals.postCellLarge
        }
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
        // MARK: - fix me
//        navigationController?.pushViewController(webViewController, animated: true)
    }
}
