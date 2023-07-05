//
//  HomeMenuBar.swift
//  VelogOnMobile
//
//  Created by 장석우 on 2023/06/02.
//

import UIKit

protocol HomeMenuBarDelegate: AnyObject {
    func menuBar(didSelectItemAt item: Int)
}


final class HomeMenuBar: UIView {
    
    //MARK: - Properties
    
    weak var delegate: HomeMenuBarDelegate?
    
    var selectedItem: Int? {
        didSet {
            updateBar(from: selectedItem)
        }
    }
    
    private var menuData = HomeMenuCollectionViewCell.MenuType.allCases
    
    
    private var tags: [String] = [] {
        didSet {
            calculateCellSize()
            collectionView.reloadData()
            selectedItem = 1
        }
    }
    
    private var menuSizes: [CGSize] = [CGSize(width: 65, height: 40),
                                       CGSize(width: 75, height: 40),
                                       CGSize(width: 75, height: 40)]
    
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
        addSubviews(collectionView,underLine)
        
        collectionView.addSubview(tintLine)
        
    }
    
    func layout() {
        self.layoutIfNeeded()
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        underLine.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalTo(collectionView)
            $0.size.equalTo(1)
        }
        
        tintLine.snp.makeConstraints {
            $0.bottom.equalTo(underLine).offset(-1)
            $0.leading.equalToSuperview().offset(65)
            $0.width.equalTo(75)
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
    
    func updateBar(from index: Int?) {
        guard let index else { return }
        let indexPath = IndexPath(item: index, section: 0)
        
        collectionView.selectItem(at: indexPath,
                                  animated: true,
                                  scrollPosition: .centeredHorizontally)
        
        updateTintBar(index: index)
    }
    
    func updateTintBar(index: Int) {
        
        var leading: CGFloat = 0
        
        for i in 0..<index {
            leading += menuSizes[i].width
        }
        
        layoutIfNeeded()
        
        tintLine.snp.remakeConstraints { $0
            $0.bottom.equalTo(underLine).offset(-1)
            $0.leading.equalToSuperview().offset(leading)
            $0.width.equalTo(menuSizes[index])
            $0.height.equalTo(3)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    func calculateCellSize() {
        var sizes = [CGSize(width: 65, height: 40),
                         CGSize(width: 75, height: 40),
                         CGSize(width: 75, height: 40)]
        
        for tag in tags {
            let cell = HomeMenuCollectionViewCell()
            cell.dataBind(.tag, keyword: tag)
            let size =  cell.sizeFittingWith(cellHeight: 40)
            sizes.append(size)
        }
        
        menuSizes = sizes
    }
}

//MARK: - UICollectionViewDataSource

extension HomeMenuBar: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3 + tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.row {
        case 0...2:
            let cell: HomeMenuCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.dataBind(menuData[indexPath.row], keyword: nil)
            return cell
        default:
            let cell: HomeMenuCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.dataBind(.tag, keyword: tags[indexPath.item - 3])
            return cell
        }
    }
}

//MARK: - UICollectionViewDelegate

extension HomeMenuBar: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        delegate?.menuBar(didSelectItemAt: indexPath.item)
        return indexPath.item != 0
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension HomeMenuBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return menuSizes[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

