//
//  PostsViewController.swift
//  VelogOnMobile
//
//  Created by 장석우 on 2023/06/02.
//

import UIKit

import SnapKit

final class HomeViewController: BaseViewController {
    
    //MARK: - Properties
    
    private var currentIndex: Int = 1 {
        didSet {
            changeViewController(before: oldValue, after: currentIndex)
        }
    }
    
    private var tags: [String] = [] {
        didSet {
            menuBar.dataBind(tags: tags)
            setPageViewController()
        }
    }
    
    //MARK: - PageViewController
    
    private lazy var pageViewController: UIPageViewController = {
        let viewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        return viewController
    }()
    
    private var dataSourceViewController: [UIViewController] = []

    
    //MARK: - UI Components
    
    private let navigationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiterals.homeViewControllerHeadTitle
        label.font = .display
        return label
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.searchIcon, for: .normal)
        button.addTarget(self, action: #selector(moveToSearchPostViewController), for: .touchUpInside)
        return button
    }()
    
    private let menuBar = HomeMenuBar()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate()
        style()
        hierarchy()
        layout()
        requestGetTagAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - Custom Method
    
    private func delegate() {
        menuBar.delegate = self
        pageViewController.dataSource = self
        pageViewController.delegate = self
    }
    
    private func style() {
        view.backgroundColor = .gray100
    }
    
    private func hierarchy() {
        addChild(pageViewController)
        view.addSubviews(navigationView, menuBar)
        view.addSubview(pageViewController.view)
        
        navigationView.addSubviews(titleLabel, searchButton)
    }
    
    private func layout() {
        // view
        navigationView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(132)
        }
        
        menuBar.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        pageViewController.view.snp.makeConstraints { 
            $0.top.equalTo(menuBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        pageViewController.didMove(toParent: self)
        
        // naviagtionView
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(76)
            $0.leading.equalToSuperview().inset(17)
        }
        
        searchButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(22)
            $0.size.equalTo(30)
        }
    }
    
    private func setPageViewController() {
        let factory = KeywordPostsVCFactory()
        dataSourceViewController = [ColorViewController(color: .black),
                                    PostsViewController(viewModel: .init(viewType: .trend)),
                                    PostsViewController(viewModel: .init(viewType: .follow))]
        
        
        for tag in tags {
            let vc = factory.create(tag: tag)
            dataSourceViewController.append(vc)
        }
        
        currentIndex = 1
    }
    
    private func changeViewController(before beforeIndex: Int, after newIndex: Int) {
        
        let direction: UIPageViewController.NavigationDirection = beforeIndex < newIndex ? .forward : .reverse
        
        
        pageViewController.setViewControllers([dataSourceViewController[currentIndex]],
                                              direction: direction,
                                              animated: true,
                                              completion: nil)
        menuBar.selectedItem = newIndex
    }
    
    //TODO: - MVVM 리팩시 ViewModel이 담당
    private func requestGetTagAPI() {
        NetworkService.shared.tagRepository.getTag { result in
            switch result {
            case .success(let response):
                guard let response = response as? [String] else { return }
                self.tags = response
            default :
                ServerFailViewController.show()
                return
            }
        }
    }
    
    //MARK: - Action Method
    
    @objc
    private func moveToSearchPostViewController() {
        let postSearchViewModel = PostSearchViewModel()
        let searchPostViewController = SearchViewController(viewModel: postSearchViewModel)
        navigationController?.pushViewController(searchPostViewController, animated: true)
    }
}

extension HomeViewController: HomeMenuBarDelegate {
    func menuBar(didSelectItemAt item: Int) {
        if item == 0 {
            let tagSearchVC = TagSearchViewController(viewModel: TagSearchViewModel())
            navigationController?.pushViewController(tagSearchVC, animated: true)
            return
        }
        currentIndex = item
    }
}

//MARK: - UIPageViewControllerDataSource

extension HomeViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = dataSourceViewController.firstIndex(of: viewController) else { return nil }
        let nextIndex = currentIndex + 1
        guard nextIndex != dataSourceViewController.count else { return nil }
        return dataSourceViewController[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = dataSourceViewController.firstIndex(of: viewController) else { return nil }
        let previousIndex = currentIndex - 1
        guard previousIndex >= 1 else { return nil }
        return dataSourceViewController[previousIndex]
    }
}

//MARK: - UIPageViewControllerDelegate

extension HomeViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        
        guard let currentVC = pageViewController.viewControllers?.first,
              let currentIndex = dataSourceViewController.firstIndex(of: currentVC) else { return }
        self.currentIndex = currentIndex
    }
}

