//
//  SubscriberListTableViewCell.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//

import UIKit

import SnapKit

final class SubscriberListTableViewCell: BaseTableViewCell {
    
    static let identifier = "CellId"

    private enum Size {
        static let collectionHorizontalSpacing: CGFloat = 0
        static let collectionVerticalSpacing: CGFloat = 0
        static let cellWidth: CGFloat = 24
        static let cellHeight: CGFloat = 24
        static let collectionInsets = UIEdgeInsets(
            top: collectionVerticalSpacing,
            left: collectionHorizontalSpacing,
            bottom: collectionVerticalSpacing,
            right: collectionHorizontalSpacing)
    }
    
    var subscriberName: UILabel = {
        let label = UILabel()
        label.text = "홍준혁"
        label.tintColor = .black
        return label
    }()
    
    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = Size.collectionInsets
        flowLayout.itemSize = CGSize(width: Size.cellWidth, height: Size.cellHeight)
        return flowLayout
    }()
    private lazy var workerCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.register(cell: WorkerCollectionViewCell.self,
                                forCellWithReuseIdentifier: WorkerCollectionViewCell.className)
        return collectionView
    }()

    // MARK: - life cycle
    
    override func render(){
        self.addSubview(shadowLayer)
        shadowLayer.addSubview(mainBackground)
        mainBackground.addSubviews(workLabel,workerCollectionView,timeStackView,roomStackView)

        mainBackground.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        shadowLayer.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        pinImage.snp.makeConstraints {
            $0.width.height.equalTo(18)
        }
        
        workLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(SizeLiteral.componentPadding)
            $0.leading.equalToSuperview().offset(SizeLiteral.componentPadding)
        }
        
        workerCollectionView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(SizeLiteral.componentPadding)
            $0.leading.equalToSuperview().offset(SizeLiteral.componentPadding)
            $0.height.equalTo(24)
            $0.width.equalTo(190)
        }

        timeStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(SizeLiteral.componentPadding)
            $0.trailing.equalToSuperview().inset(SizeLiteral.componentPadding)
        }
        
        roomStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(SizeLiteral.componentPadding)
            $0.trailing.equalToSuperview().inset(SizeLiteral.componentPadding)
        }
    }
    
    override func configUI() {
        self.mainBackground.layer.cornerRadius = 10
        self.mainBackground.layer.borderWidth = 1
        self.mainBackground.layer.borderColor = UIColor.positive10.cgColor
        self.mainBackground.layer.masksToBounds = false
        self.shadowLayer.backgroundColor = .gray400
        self.shadowLayer.layer.cornerRadius = 10
        self.shadowLayer.layer.masksToBounds = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.shadowLayer.backgroundColor = .gray100
        self.shadowLayer.layer.cornerRadius = 10
        self.mainBackground.layer.cornerRadius = 10
        self.mainBackground.layer.borderWidth = 1
        self.mainBackground.layer.borderColor = UIColor.positive10.cgColor
        self.mainBackground.backgroundColor = .white
        self.workLabel.text = String()
        self.errorImage.image = UIImage()
        self.time.text = String()
        self.room.text = String()
    }
    
    func setErrorImageView() {
        self.errorImage.image = ImageLiterals.error
    }
}

extension SubscriberListTableViewCell: UICollectionViewDelegate {}

extension SubscriberListTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memberListProfilePath.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WorkerCollectionViewCell.className, for: indexPath) as? WorkerCollectionViewCell else {
            assert(false, "Wrong Cell")
            return UICollectionViewCell()
        }
        if let profile = self.memberListProfilePath[indexPath.row].profilePath {
            cell.workerIconImage.load(from: profile)
        }
        return cell
    }
}
