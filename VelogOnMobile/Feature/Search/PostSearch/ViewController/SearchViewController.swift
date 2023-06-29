//
//  SearchViewController.swift
//  VelogOnMobile
//
//  Created by JuHyeonAh on 2023/06/08.
//

import UIKit

import RxSwift
import RxRelay

final class SearchViewController: RxBaseViewController<PostSearchViewModel> {
    
    private var popularSearchTagList: [String] = [] {
        didSet {
            self.popularSearchTagTableView.reloadData()
        }
    }
    
    private let flowLayout = UICollectionViewFlowLayout()
    
    private lazy var recentSearchTagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    
    private let popularSearchTagTableView = UITableView()
    
    private let recentLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiterals.postSearchViewRecentLabel
        label.font = .headline
        label.textColor = .gray700
        label.textAlignment = .center
        return label
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextLiterals.postSearchViewDeleteAllRecentDataButtonText, for: .normal)
        button.titleLabel?.font = .caption_1_M
        button.backgroundColor = .white
        button.setTitleColor(.gray200, for: .normal)
        button.titleLabel?.textAlignment = NSTextAlignment.center
        return button
    }()
    
    private let trendLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiterals.postSearchViewTrendLabel
        label.font = .body_2_B
        label.textColor = .gray700
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        setCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 280, height: 0))
        searchBar.placeholder = TextLiterals.postSearchViewSearchBarPlaceholderText
        self.navigationItem.titleView = searchBar

        searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak searchBar] in
                guard let searchText = searchBar?.text else { return }
            })
            .disposed(by: disposeBag)
    }
    
    override func render() {
        view.addSubviews(
            recentLabel,
            deleteButton,
            recentSearchTagCollectionView,
            trendLabel,
            popularSearchTagTableView
        )
        
        recentLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(125)
            $0.leading.equalToSuperview().offset(35)
        }
        
        deleteButton.snp.makeConstraints{
            $0.top.equalToSuperview().offset(120)
            $0.trailing.equalToSuperview().inset(35)
        }
        
        recentSearchTagCollectionView.snp.makeConstraints{
            $0.top.equalTo(recentLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(35)
        }
        
        trendLabel.snp.makeConstraints{
            $0.top.equalTo(recentSearchTagCollectionView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(35)
        }
        
        popularSearchTagTableView.snp.makeConstraints{
            $0.top.equalTo(trendLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(35)
            $0.bottom.equalToSuperview().inset(100)
        }
    }
    
    override func bind(viewModel: PostSearchViewModel) {
        super.bind(viewModel: viewModel)
        bindOutput(viewModel)
    }
    
    private func bindOutput(_ viewModel: PostSearchViewModel) {
        viewModel.popularPostKeywordListOutput
            .asDriver(onErrorJustReturn: [String]())
            .drive(onNext: { [weak self] popularPostKeywordList in
                guard let self = self else { return }
                self.popularSearchTagList = popularPostKeywordList
            })
            .disposed(by: disposeBag)
    }
}

extension SearchViewController {
    func setTableView(){
        popularSearchTagTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "SearchTableViewCell")
        popularSearchTagTableView.delegate = self
        popularSearchTagTableView.dataSource = self
        popularSearchTagTableView.separatorStyle = .none
        popularSearchTagTableView.rowHeight = UITableView.automaticDimension
        popularSearchTagTableView.estimatedRowHeight = UITableView.automaticDimension
        popularSearchTagTableView.showsVerticalScrollIndicator = false
    }
    
    func setCollectionView() {
        recentSearchTagCollectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: "SearchCollectionViewCell")
        recentSearchTagCollectionView.showsHorizontalScrollIndicator = false
        recentSearchTagCollectionView.delegate = self
        recentSearchTagCollectionView.dataSource = self
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 100, height: 30)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popularSearchTagList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        if indexPath.row < 3 {
            cell.numLabel.textColor = .brandColor
        }
        cell.selectionStyle = .none
        cell.configCell(self.popularSearchTagList[indexPath.row], indexPath.row)
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell()
        }
//        cell.configCell(popularSearchTagList[indexPath.item])
        return cell
    }
}
