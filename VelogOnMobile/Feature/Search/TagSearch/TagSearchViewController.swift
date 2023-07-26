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
    
    //MARK: - Properties
    
    //MARK: - UI Components
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 280, height: 0))
        searchBar.placeholder = TextLiterals.tagSearchPlaceholderText
        searchBar.searchTextField.textColor = .gray500
        searchBar.setImage(ImageLiterals.tagPlusIcon,
                           for: .search,
                           state: .normal)
        searchBar.delegate = self
        searchBar.searchTextField.returnKeyType = .done
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
        view.backgroundColor = .white
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
        button.isHidden = true //TODO: 마이태그 <모두 지우기> 기능 존재 유무에 따라 hidden값 처리. 1차 릴리즈엔 hidden 처리
        return button
    }()
    
    private lazy var myTagCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize.height = 36
        layout.sectionInset = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cell: MyTagCollectionViewCell.self)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let myTagEmptyLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "저장한 태그가 없습니다."
        label.font = .body_1_M
        label.textColor = .gray300
        return label
    }()
    
    private let popularTagLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiterals.popularTag
        label.textColor = .gray700
        label.font = .body_2_B
        return label
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    private lazy var popularTagTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(cell: PopularTagTableViewCell.self)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.rowHeight = 40
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
        
        
        let input = TagSearchViewModel.Input(
            searchBarDidEditEvent: searchBar.searchTextField.rx.text.orEmpty.asObservable(),
            searchTextFieldDidEnd: searchBar.searchTextField.rx.controlEvent(.editingDidEnd).asObservable(),
            myTagCellDidTap: myTagCollectionView.rx.modelSelected(String.self).asObservable()
        )
        
        viewModel.transform(input)

        self.bindOutput(viewModel)
    }
    
    private func bindOutput(_ viewModel: TagSearchViewModel) {
        viewModel.myTagsOutput
            .asDriver(onErrorJustReturn: [])
            .drive(
                myTagCollectionView.rx.items(cellIdentifier: MyTagCollectionViewCell.reuseIdentifier,
                                                   cellType: MyTagCollectionViewCell.self)
            ) { index, tag, cell in
                cell.updateUI(keyword: tag)
            }
            .disposed(by: disposeBag)
        
        viewModel.popularTagsOutput
            .asDriver(onErrorJustReturn: [])
            .drive(
                popularTagTableView.rx.items(cellIdentifier: PopularTagTableViewCell.reuseIdentifier,
                                                   cellType: PopularTagTableViewCell.self)
            ) { index, tag, cell in
                cell.updateUI(index: index, tag: tag)
            }
            .disposed(by: disposeBag)
        
        viewModel.tagAddStatusOutput
            .asDriver(onErrorJustReturn: (Bool(), String()))
            .drive { [weak self] isSuccess, message in
                guard let self = self else { return }
                let toastColor: UIColor = isSuccess ? .brandColor : .gray300
                self.showToast(toastText: message, backgroundColor: toastColor)
                self.collectionViewScrollToEnd()
            }
            .disposed(by: disposeBag)
        
        viewModel.presentDeleteMyTagAlertOutput
            .asDriver(onErrorJustReturn: false)
            .drive { [weak self] bool in
                guard let self = self else { return }
                let alertVC = VelogAlertViewController(alertType: .deleteTag,
                                                       delegate: self)
                self.present(alertVC, animated: false)
            }
            .disposed(by: disposeBag)
        
        viewModel.deleteTagStatusOutPut
            .asDriver(onErrorJustReturn: (Bool(), String()))
            .drive { [weak self] isSuccess, message in
                guard let self = self else { return }
                let toastColor: UIColor = isSuccess ? .brandColor : .gray300
                self.showToast(toastText: message, backgroundColor: toastColor)
                self.collectionViewScrollToEnd()
            }
            .disposed(by: disposeBag)
        
        viewModel.myTagsEmpty
            .asDriver(onErrorJustReturn: Bool())
            .drive { [weak self] isEmpty in
                guard let self = self else { return }
                if isEmpty {
                    self.myTagEmptyLabel.isHidden = false
                } else {
                    self.myTagEmptyLabel.isHidden = true
                }
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
                                lineView,
                                popularTagLabel,
                                popularTagTableView)
        
        myTagView.addSubviews(myTagLabel,
                              removeAllButton,
                              myTagCollectionView,
                              myTagEmptyLabel)
        
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
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(myTagCollectionView.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(6)
        }
        
        popularTagLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(20)
        }
        
        popularTagTableView.snp.makeConstraints {
            $0.top.equalTo(popularTagLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(70)
        }
        
        //MARK: MyTagView
        
        myTagLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        removeAllButton.snp.makeConstraints {
            $0.centerY.equalTo(myTagLabel)
            $0.trailing.equalToSuperview().inset(28)
        }
        
        myTagCollectionView.snp.makeConstraints {
            $0.top.equalTo(myTagLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        
        myTagEmptyLabel.snp.makeConstraints {
            $0.top.equalTo(myTagLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(16)
        }
        
    }
    
    private func collectionViewScrollToEnd() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let contentHeight = self.myTagCollectionView.contentSize.width
            let offsetX = max(0, contentHeight - self.myTagCollectionView.frame.width)
            self.myTagCollectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        }
    }
    
}

extension TagSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
    
}

extension TagSearchViewController: VelogAlertViewControllerDelegate {
    
    func yesButtonDidTap(_ alertType: AlertType) {
        viewModel?.myTagDeleteEvent()
    }
    
}
