//
//  SearchViewController.swift
//  VelogOnMobile
//
//  Created by JuHyeonAh on 2023/06/08.
//

import UIKit

import SnapKit
import RxSwift
import RxRelay

final class PostSearchViewController: RxBaseViewController<PostSearchViewModel> {
    
    private var popularSearchTagList: [String] = [] {
        didSet {
            self.popularSearchTagTableView.reloadData()
        }
    }
    private var currentSearchTagList: [String] = [] {
        didSet {
            self.recentSearchTagCollectionView.reloadData()
        }
    }
    private var searchedTag: String = String()
    
    private let flowLayout = UICollectionViewFlowLayout()
    private lazy var recentSearchTagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    
    private let popularSearchTagTableView = UITableView()
    private let tapGesture = UITapGestureRecognizer()
    private let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 280, height: 0))
    
    
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
    
    private let emptyRecentSearchTagExcaptionLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "최근 검색어가 없습니다."
        label.font = .body_1_M
        label.textColor = .gray300
        return label
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
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
        setTagGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        searchBar.placeholder = TextLiterals.postSearchViewSearchBarPlaceholderText
        self.navigationItem.titleView = searchBar
    }
    
    override func render() {
        view.addSubviews(
            recentLabel,
            deleteButton,
            emptyRecentSearchTagExcaptionLabel,
            recentSearchTagCollectionView,
            lineView,
            trendLabel,
            popularSearchTagTableView
        )
        
        recentLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(125)
            $0.leading.equalToSuperview().offset(20)
        }
        
        deleteButton.snp.makeConstraints{
            $0.top.equalToSuperview().offset(120)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        emptyRecentSearchTagExcaptionLabel.snp.makeConstraints {
            $0.top.equalTo(recentLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        view.bringSubviewToFront(emptyRecentSearchTagExcaptionLabel)
        
        recentSearchTagCollectionView.snp.makeConstraints{
            $0.top.equalTo(recentLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(35)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(recentSearchTagCollectionView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(6)
        }
        
        trendLabel.snp.makeConstraints{
            $0.top.equalTo(lineView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }
        
        popularSearchTagTableView.snp.makeConstraints{
            $0.top.equalTo(trendLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(100)
        }
    }
    
    override func bind(viewModel: PostSearchViewModel) {
        super.bind(viewModel: viewModel)
        bindOutput(viewModel)
        
        searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak searchBar] in
                guard let searchText = searchBar?.text else { return }
                self.viewModel?.searchPostTagInput.accept(searchText)
                self.searchedTag = searchText
                
                self.viewModel?.addCurrentSearchTagInput.accept(searchText)
            })
            .disposed(by: disposeBag)
        
        tapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel?.deleteAllCurrentSearchTagInput.accept(Void())
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(_ viewModel: PostSearchViewModel) {
        viewModel.popularPostKeywordListOutput
            .asDriver(onErrorJustReturn: [String]())
            .drive(onNext: { [weak self] popularPostKeywordList in
                guard let self = self else { return }
                self.popularSearchTagList = popularPostKeywordList
            })
            .disposed(by: disposeBag)
        
        viewModel.searchPostOutput
            .asDriver(onErrorJustReturn: [PostDTO]())
            .drive(onNext: { [weak self] searchPostResponse in
                if searchPostResponse.isEmpty {
                    self?.showToast(toastText: "검색 결과가 없습니다.", backgroundColor: .gray300)
                } else {
                    guard let searchTag = self?.searchedTag else { return }
                    guard let tagSearchViewController = self?.makeSearchPostViewController(
                        tag: searchTag,
                        postDTOList: searchPostResponse
                    ) else {
                        return
                    }
                    self?.navigationController?.pushViewController(tagSearchViewController, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.currentSearchTagListOutput
            .asDriver(onErrorJustReturn: [String]())
            .drive(onNext: { [weak self] currentSearchTagList in
                self?.setEmptyRecentSearchTagExcaptionLabel(isCurrentSearchTagListEmpty: currentSearchTagList.isEmpty)
                self?.currentSearchTagList = currentSearchTagList
            })
            .disposed(by: disposeBag)
    }
    
    private func makeSearchPostViewController(
        tag: String,
        postDTOList: [PostDTO]
    ) -> UIViewController {
        let factory = KeywordPostsVCFactory()
        let viewController = factory.create(
            tag: tag,
            isNavigationBarHidden: false,
            postDTOList: postDTOList
        )
        return viewController
    }
    
    private func setTagGesture() {
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setEmptyRecentSearchTagExcaptionLabel(
        isCurrentSearchTagListEmpty: Bool
    ) {
        if isCurrentSearchTagListEmpty {
            emptyRecentSearchTagExcaptionLabel.isHidden = false
        } else {
            emptyRecentSearchTagExcaptionLabel.isHidden = true
        }
    }
}

extension PostSearchViewController {
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
        flowLayout.estimatedItemSize.height = 30
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.sectionInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        
    }
}

extension PostSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        cell.configCell(self.popularSearchTagList[indexPath.row], indexPath.row + 1)
        return cell
    }
}

extension PostSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.currentSearchTagList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell()
        }
        cell.configCell(currentSearchTagList[indexPath.row])
        return cell
    }
}
