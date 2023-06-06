//
//  ScrapStorageCollectionViewDataSource.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/29.
//

import UIKit

final class ScrapStorageCollectionViewDataSource {
    
    typealias collectionCell = ScrapStorageCollectionViewCell
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, UUID>
    typealias DiffableSnapshot = NSDiffableDataSourceSnapshot<ScrapStorageCollectionViewDataSource.Section, UUID>
    typealias CompletedUpdate = (() -> Void)

    private let collectionView: UICollectionView

    private lazy var dataSource: DiffableDataSource = createDataSource()
    private var folderData: [StorageDTO]

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
        return UICollectionViewDiffableDataSource<Section, UUID>(
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
        folderData: [StorageDTO]?,
        completion: CompletedUpdate? = nil
    ) {
        guard let folderData = folderData else {
            completion?()
            return
        }
        let itemIdentifiers = folderData.compactMap { $0.articleID }
        self.folderData = folderData
        dataSource = createDataSource()
        
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
