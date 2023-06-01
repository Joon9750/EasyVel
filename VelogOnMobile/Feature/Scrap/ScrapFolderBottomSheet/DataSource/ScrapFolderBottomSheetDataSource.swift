//
//  ScrapFolderBottomSheetDataSource.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/28.
//

import UIKit

final class ScrapFolderBottomSheetDataSource {
    
    typealias tableViewCell = ScrapFolderBottomSheetTableViewCell
    typealias DiffableDataSource = UITableViewDiffableDataSource<Section, UUID>
    typealias DiffableSnapshot = NSDiffableDataSourceSnapshot<ScrapFolderBottomSheetDataSource.Section, UUID>
    typealias CompletedUpdate = (() -> Void)

    private let tableView: UITableView

    private lazy var dataSource: DiffableDataSource = createDataSource()
    private var folderNameList: [ScrapFolder]

    enum Section {
        case main
    }
    
    init(
        tableView: UITableView
    ) {
        self.tableView = tableView
        self.folderNameList = .init()
    }

    private func createDataSource() -> DiffableDataSource {
        return UITableViewDiffableDataSource<Section, UUID>(
            tableView: tableView
        ) { [weak self] _, indexPath, _ in
            guard let self = self else {
                return UITableViewCell()
            }
            let folderTitle = self.folderNameList[indexPath.row].title
            let cell:tableViewCell = self.tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(folderList: folderTitle ?? "")
            return cell
        }
    }

    func update(
        list: [ScrapFolder]?,
        completion: CompletedUpdate? = nil
    ) {
        guard let list = list else {
            completion?()
            return
        }
        self.folderNameList = list
        
        let itemIdentifiers = list.compactMap { $0.articleId }
        list.forEach { folderName in
            self.folderNameList.append(folderName)
        }
        
        var snapshot = dataSource.snapshot()
        if snapshot.sectionIdentifiers.contains(Section.main) == false {
            snapshot.appendSections([.main])
        }
        snapshot.appendItems(itemIdentifiers, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true) {
            completion?()
        }
    }
}
