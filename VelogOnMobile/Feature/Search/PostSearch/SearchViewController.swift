//
//  SearchViewController.swift
//  VelogOnMobile
//
//  Created by JuHyeonAh on 2023/06/08.
//
import UIKit

import SnapKit

final class SearchViewController: BaseViewController {
    
    private let dummy = Trend.dummy()

    private let flowLayout = UICollectionViewFlowLayout()

    private lazy var recentSearchTagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    private let popularSearchTagTableView = UITableView()
    
    private let recentLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 검색어"
        label.font = UIFont(name: "Avenir-Black", size: 20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("모두 지우기", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Black", size: 12)
        button.backgroundColor = .white
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.textAlignment = NSTextAlignment.center
        return button
    }()
    
    private let trendLabel: UILabel = {
        let label = UILabel()
        label.text = "인기 키워드"
        label.font = UIFont(name: "Avenir-Black", size: 16)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
        setCollectionView()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 280, height: 0))
        searchBar.placeholder = "통합검색"
        self.navigationItem.titleView = searchBar
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
        return dummy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        if indexPath.row < 3 {
            cell.numLabel.textColor = .brandColor
        }
        cell.selectionStyle = .none
        cell.configCell(dummy[indexPath.row])
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
        cell.configCell(dummy[indexPath.item])
        return cell
    }
}

struct Trend {
    let keyword: String
    let num: String
}

extension Trend{
    static func dummy() -> [Trend]{
        return [Trend(keyword: "iOS",
                      num: "1"),
                Trend(keyword: "Android",
                      num: "2"),
                Trend(keyword: "Sever",
                      num: "3"),
                Trend(keyword: "Design",
                      num: "4"),
                Trend(keyword: "알고리즘",
                      num: "5"),
                Trend(keyword: "TIL",
                      num: "6"),
                Trend(keyword: "프로그래머스",
                      num: "7"),
                Trend(keyword: "코딩테스트",
                      num: "8"),
                Trend(keyword: "Spring",
                      num: "9"),
                Trend(keyword: "CSS",
                      num: "10"),
        ]
    }
}
