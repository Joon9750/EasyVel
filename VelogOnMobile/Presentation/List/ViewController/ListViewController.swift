//
//  ListViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/30.
//

import UIKit

final class ListViewController: BaseViewController {
    
    private let listView = ListView()
    private var viewModel: ListViewModelInputOutput?
    private var tagList: [String]? {
        didSet {
            listView.listTableView.reloadData()
        }
    }
    private var subscriberList: [String]? {
        didSet {
            listView.listTableView.reloadData()
        }
    }
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func render() {
        self.view = listView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.viewWillAppear()
    }
    
    override func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func bind() {
        listView.postsHeadView.addButton.addTarget(self, action: #selector(presentActionSheet), for: .touchUpInside)
        listView.listTableView.dataSource = self
        listView.listTableView.delegate = self
        viewModel?.tagListOutput = { [weak self] list in
            self?.tagList = list
        }
        viewModel?.subscriberListOutput = { [weak self] list in
            self?.subscriberList = list
        }
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // MARK: - fix
        switch section {
        case 0: return tagList?.count ?? 0
        case 1: return subscriberList?.count ?? 0
        default: return Int()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier) as? ListTableViewCell ?? ListTableViewCell()
        cell.selectionStyle = .none
        let section = indexPath.section
        let row = indexPath.row
        switch section {
        case 0: cell.listText.text = tagList?[row]
        case 1: cell.listText.text = subscriberList?[row]
        default: return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let selectedCell = tableView.cellForRow(at: indexPath) as! ListTableViewCell
        let section = indexPath.section
        switch section {
        case 0:
            let swipeAction = UIContextualAction(style: .destructive, title: "삭제", handler: { action, view, completionHaldler in
                if let tag = selectedCell.listText.text {
                    self.viewModel?.tagDeleteButtonDidTap(tag: tag)
                }
                completionHaldler(true)
            })
            let configuration = UISwipeActionsConfiguration(actions: [swipeAction])
            return configuration
        case 1:
            let swipeAction = UIContextualAction(style: .destructive, title: "삭제", handler: { action, view, completionHaldler in
                if let target = selectedCell.listText.text {
                    self.viewModel?.subscriberDeleteButtonDidTap(target: target)
                }
                completionHaldler(true)
            })
            let configuration = UISwipeActionsConfiguration(actions: [swipeAction])
            return configuration
        default:
            let configuration = UISwipeActionsConfiguration()
            return configuration
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Keywords"
        case 1: return "Subscribers"
        default: return String()
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
}

// MARK: - button Action

private extension ListViewController {
    @objc
    func presentActionSheet() {
        let searchKeywordButtonAction = UIAlertAction(title: "Keyword", style: .default) { [weak self] action in
            self?.addKeywordButtonTap()
        }
        let searchSubscriberButtonAction = UIAlertAction(title: "Subscriber", style: .default) { [weak self] action in
            self?.addSubscriberButtonTap()
        }
        let cancelAction = UIAlertAction(title: "Canel", style: .cancel)
        let actionSheet = UIAlertController(title: "추가", message: "추가할 기준을 선택해주세요.", preferredStyle: .actionSheet)
        actionSheet.addAction(searchKeywordButtonAction)
        actionSheet.addAction(searchSubscriberButtonAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true)
    }
    
    func addKeywordButtonTap() {
        let tagSerchViewModel = TagSearchViewModel()
        let tagSearchVC = TagSearchViewController(viewModel: tagSerchViewModel)
        tagSearchVC.modalPresentationStyle = .pageSheet
        if let sheet = tagSearchVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        present(tagSearchVC, animated: true)
    }
    
    func addSubscriberButtonTap() {
        let viewModel = SubscriberSearchViewModel()
        let subscriberSearchVC = SubscriberSearchViewController(viewModel: viewModel)
        subscriberSearchVC.modalPresentationStyle = .pageSheet
        if let sheet = subscriberSearchVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        present(subscriberSearchVC, animated: true)
    }
}
