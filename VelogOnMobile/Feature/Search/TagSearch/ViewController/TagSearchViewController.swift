//
//  KeywordSearchViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/30.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class TagSearchViewController: RxBaseViewController<TagSearchViewModel> {
    
    //private let searchView = TagSearchView()
    
    //MARK: - Properties
    
    //MARK: - UI Components
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 280, height: 0))
        searchBar.placeholder = TextLiterals.tagSearchPlaceholderText
        searchBar.searchTextField.textColor = .gray500
        searchBar.setImage(ImageLiterals.tagPlusIcon,
                           for: .search,
                           state: .normal)
        return searchBar
    }()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.bounces = false
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    
    private let contentView = UIView()
    
    private let myTagView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    private let myTagLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiterals.myTag
        label.font = .headline
        label.textColor = .gray700
        return label
    }()
    
    private let removeAllButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextLiterals.deleteAll, for: .normal)
        button.setTitleColor( .gray200, for: .normal)
        button.titleLabel?.font = .caption_1_M
        return button
    }()
    
    private lazy var myTagCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize.height = 40
        layout.sectionInset = .init(top: 0, left: 12, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cell: MyTagCollectionViewCell.self)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let popularTagLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiterals.popularTag
        label.textColor = .gray700
        label.font = .body_2_B
        return label
    }()
    
    private lazy var popularTagTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(cell: PopularTagTableViewCell.self)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.rowHeight = 30
        return tableView
    }()
    
    //MARK: - Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hierarchy()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNaviagtionBar()
        
    }
    
    //MARK: - Bind
    
    override func bind(viewModel: TagSearchViewModel) {
        super.bind(viewModel: viewModel)
        bindOutput(viewModel)
        
        
    }
    
    private func bindOutput(_ viewModel: TagSearchViewModel) {
        viewModel.myTagsOutput
            .asDriver(onErrorJustReturn: [])
            .drive(
                myTagCollectionView.rx.items(cellIdentifier: MyTagCollectionViewCell.reuseIdentifier,
                                                   cellType: MyTagCollectionViewCell.self)
            ) { index, tag, cell in
                cell.dataBind(data: tag)
            }
            .disposed(by: disposeBag)
        
        viewModel.popularTagsOutput
            .asDriver(onErrorJustReturn: [])
            .drive(
                popularTagTableView.rx.items(cellIdentifier: PopularTagTableViewCell.reuseIdentifier,
                                                   cellType: PopularTagTableViewCell.self)
            ) { index, tag, cell in
                cell.dataBind(index: index, data: tag)
            }
            .disposed(by: disposeBag)
    }
    
    
    
}

//MARK: - Custom Method

private extension TagSearchViewController {
    
    func setNaviagtionBar() {
        navigationController?.navigationBar.isHidden = false
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.shadowColor = .gray200
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.standardAppearance.shadowColor = .gray200
    }
    
    func hierarchy() {
        navigationItem.titleView = searchBar
        
        view.addSubviews(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(myTagView,
                                popularTagLabel,
                                popularTagTableView)
        
        myTagView.addSubviews(myTagLabel,
                              removeAllButton,
                              myTagCollectionView)
        
    }
    
    func layout() {
        scrollView.snp.makeConstraints {
            $0.verticalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.height.equalTo(scrollView.frameLayoutGuide).priority(.low)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        //MARK: ContentView
        
        myTagView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        popularTagLabel.snp.makeConstraints {
            $0.top.equalTo(myTagView.snp.bottom).offset(44)
            $0.leading.equalToSuperview().inset(20)
        }
        
        popularTagTableView.snp.makeConstraints {
            $0.top.equalTo(popularTagLabel.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(80)
            //$0.height.equalTo(2000)
        }
        
        //MARK: MyTagView
        
        myTagLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(20)
        }
        
        removeAllButton.snp.makeConstraints {
            $0.centerY.equalTo(myTagLabel)
            $0.trailing.equalToSuperview().inset(28)
        }
        
        myTagCollectionView.snp.makeConstraints {
            $0.top.equalTo(myTagLabel.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
    }
    
}


    //    override func bind(viewModel: TagSearchViewModel) {
    //        super.bind(viewModel: viewModel)
    //        bindOutput(viewModel)
    //
    //        searchView.addTagBtn.rx.tap
    //            .flatMap { [weak self] _ -> Observable<String> in
    //                if let text = self?.searchView.textField.text {
    //                    return .just(text)
    //                } else {
    //                    return .empty()
    //                }
    //            }
    //            .bind(to: viewModel.tagAddButtonDidTap)
    //            .disposed(by: disposeBag)
    //    }
    //
    //    private func bindOutput(_ viewModel: TagSearchViewModel) {
    //        viewModel.tagAddStatusOutput
    //            .asDriver(onErrorJustReturn: (false, ""))
    //            .drive(onNext: { [weak self] isSuccess, statusText in
    //                switch isSuccess {
    //                case true:
    //                    self?.searchView.addStatusLabel.textColor = .brandColor
    //                    self?.searchView.addStatusLabel.text = statusText
    //                    self?.updateStatusLabel(text: statusText)
    //                case false:
    //                    self?.searchView.addStatusLabel.textColor = .red
    //                    self?.searchView.addStatusLabel.text = statusText
    //                    self?.updateStatusLabel(text: statusText)
    //                }
    //            })
    //            .disposed(by: disposeBag)
    //    }
    //
    //    private func updateStatusLabel(text: String) {
    //        searchView.addStatusLabel.text = text
    //        delayCompletable(1.5)
    //            .asDriver(onErrorJustReturn: ())
    //            .drive(onCompleted: { [weak self] in
    //                self?.searchView.addStatusLabel.text = TextLiterals.noneText
    //            })
    //            .disposed(by: disposeBag)
    //    }
    //
    //    private func delayCompletable(_ seconds: TimeInterval) -> Observable<Void> {
    //        return Observable<Void>.just(())
    //                .delay(.seconds(Int(seconds)), scheduler: MainScheduler.instance)
    //    }
    //}
