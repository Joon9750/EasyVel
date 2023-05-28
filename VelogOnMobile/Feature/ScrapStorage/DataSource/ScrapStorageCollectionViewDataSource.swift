//
//  ScrapStorageCollectionViewDataSource.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/29.
//

import UIKit

final class ScrapStorageCollectionViewDataSource {
    
    typealias collectionCell = ScrapStorageCollectionViewCell
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, Int>
    typealias DiffableSnapshot = NSDiffableDataSourceSnapshot<ScrapStorageCollectionViewDataSource.Section, Int>
    typealias CompletedUpdate = (() -> Void)

    private let collectionView: UICollectionView

    private lazy var dataSource: DiffableDataSource = createDataSource()
    private var folderData: [FolderDTO]

    enum Section {
        case main
    }
    
    init(
        collectionView: UICollectionView
    ) {
        self.collectionView = collectionView
        self.folderData = .init()
    }

    private func createDataSource() -> DiffableDataSource {
        return UICollectionViewDiffableDataSource<Section, Int>(
            collectionView: collectionView
        ) { [weak self] _, indexPath, _ in
            guard let self = self else {
                return UICollectionViewCell()
            }
            let folderData = self.folderData[indexPath.row]
            let cell:collectionCell = self.collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(folderData: folderData)
            return cell
        }
    }

    func update(
        folderData: [FolderDTO]?,
        completion: CompletedUpdate? = nil
    ) {
        guard let folderData = folderData else {
            completion?()
            return
        }
        self.folderData = folderData
        
        let itemIdentifiers = folderData.map { $0.articleID }
        folderData.forEach { folder in
            self.folderData.append(folder)
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
