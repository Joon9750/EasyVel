//
//  HomeMenuBar.swift
//  VelogOnMobile
//
//  Created by 장석우 on 2023/06/02.
//

import UIKit

protocol HomeMenuBarDelegate: AnyObject {
    func menuBar(didSelectItemAt indexPath: IndexPath)
}


final class HomeMenuBar: UIView {
    
    //MARK: - Properties
    
    weak var delegate: HomeMenuBarDelegate?
    
    var isSelected: Int? {
        didSet {
            updateBar(from: isSelected)
        }
    }
    
    private var tags: [String] = [""] {
        didSet {
            collectionView.reloadData()
            isSelected = 0
        }
    }
    
    //MARK: - UI Components
    
    private var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .white
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private var underLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        return view
    }()
    
    private var tintLine: UIView = {
        let view = UIView()
        view.backgroundColor = .brandColor
        return view
    }()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        hierarchy()
        layout()
        setDelegate()
        setCollectionView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public Method
    
    func dataBind(tags: [String]) {
        self.tags = tags
    }
}

private extension HomeMenuBar {
    
    func style() {
        self.backgroundColor = .clear
    }
    
    func hierarchy() {
        addSubview(collectionView)
        addSubview(underLine)
        addSubview(tintLine)
    }
    
    func layout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        underLine.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        tintLine.snp.makeConstraints {
            $0.bottom.equalTo(collectionView)
            $0.leading.equalTo(collectionView).offset(65)
            $0.width.equalTo(65)
            $0.height.equalTo(3)
        }
    
    }
    
    func setDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setCollectionView() {
        collectionView.register(cell: HomeMenuCollectionViewCell.self)
    }
    
    func updateBar(from isSelected: Int?) {
        self.layoutIfNeeded()
        guard let isSelected else { return }
        
        collectionView.selectItem(at: IndexPath(item: isSelected, section: 1),
                                  animated: true,
                                  scrollPosition: .centeredHorizontally)
        guard let cell = collectionView.cellForItem(at: IndexPath(item: isSelected, section: 1)) as? HomeMenuCollectionViewCell else { return }
        
        tintLine.snp.remakeConstraints { make in
            make.bottom.equalTo(collectionView.snp.bottom)
            make.leading.equalTo(cell.snp.leading)
            make.trailing.equalTo(cell.snp.trailing)
            make.height.equalTo(3)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
}

//MARK: - UICollectionViewDataSource

extension HomeMenuBar: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return tags.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell: HomeMenuCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.setPlusMenu()
            return cell
        case 1:
            let cell: HomeMenuCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.dataBind(tag: tags[indexPath.item])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

//MARK: - UICollectionViewDelegate

extension HomeMenuBar: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        delegate?.menuBar(didSelectItemAt: indexPath)
        return indexPath.section != 0
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension HomeMenuBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: 65, height: 40)
        case 1:
            let cell = HomeMenuCollectionViewCell()
            cell.dataBind(tag: tags[indexPath.item])
            return cell.sizeFittingWith(cellHeight: 40)
        default:
            return .zero
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

