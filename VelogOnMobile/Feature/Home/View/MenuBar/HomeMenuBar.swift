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
    
    var isSelected: Int? {
        didSet {
            updateBar(from: isSelected)
        }
    }
    
    weak var delegate: HomeMenuBarDelegate?
    
    private let labels = ["트렌드", "팔로우", "iOS", "홍준혁", "화이팅", "현아님", "화이팅"]
    
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
        view.backgroundColor = .brandColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        hierarchy()
        layout()
        setDelegate()
        setCollectionView()
    }
    
    override func draw(_ rect: CGRect) {
        self.isSelected = 0
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HomeMenuBar {
    
    func style() {
        self.backgroundColor = .clear
    }
    
    func hierarchy() {
        addSubview(collectionView)
        addSubview(underLine)
    }
    
    func layout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setCollectionView() {
        collectionView.register(HomeMenuCollectionViewCell.self, forCellWithReuseIdentifier: HomeMenuCollectionViewCell.cellId)
    }
    
    func updateBar(from isSelected: Int?) {
        guard let isSelected else { return }
        
        collectionView.selectItem(at: IndexPath(item: isSelected, section: 0),
                                  animated: true,
                                  scrollPosition: .centeredHorizontally)
        guard let cell = collectionView.cellForItem(at: IndexPath(item: isSelected, section: 0)) as? HomeMenuCollectionViewCell else { return }
        
        underLine.snp.remakeConstraints { make in
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return labels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeMenuCollectionViewCell.cellId, for: indexPath) as? HomeMenuCollectionViewCell else { return HomeMenuCollectionViewCell()}
        cell.title = labels[indexPath.item]
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension HomeMenuBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(#function) 눌림!!!! \(indexPath.row)")
        delegate?.menuBar(didSelectItemAt: indexPath)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension HomeMenuBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = HomeMenuCollectionViewCell()
        cell.title = labels[indexPath.item]
        return cell.sizeFittingWith(cellHeight: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

