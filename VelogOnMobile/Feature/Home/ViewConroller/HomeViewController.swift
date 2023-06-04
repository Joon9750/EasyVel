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
    
    private var currentPage: Int = 0 {
        didSet {
            changeViewController(before: oldValue, after: currentPage)
        }
    }
    
    //MARK: - PageViewController
    
    private lazy var pageViewController: UIPageViewController = {
        let viewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        return viewController
    }()
    
    private var dataSourceViewController: [UIViewController] = []
    
    private var keywordsPostsViewModel = KeywordsPostsViewModel()
    private var subscriberPostViewModel = SubscriberPostsViewModel()
    private lazy var keywordsPostsViewController = KeywordsPostsViewController(viewModel: keywordsPostsViewModel)
    private lazy var subscribePostsViewController = SubscribePostsViewController(viewModel: subscriberPostViewModel)
    
    //MARK: - UI Components
    
    private let navigationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiterals.homeViewControllerTitle
        label.font = .avenir(ofSize: 26)
        return label
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.searchIcon, for: .normal)
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
        
        setPageViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentPage = 0
    }
    
    //MARK: - Custom Method
    
    private func delegate() {
        menuBar.delegate = self
        pageViewController.dataSource = self
        pageViewController.delegate = self
    }
    
    private func style() {
        view.backgroundColor = .systemGray2
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
            $0.height.equalTo(122)
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
            $0.top.equalToSuperview().inset(80)
            $0.leading.equalToSuperview().inset(17)
        }
        
        searchButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(54)
            $0.trailing.equalToSuperview().inset(24)
            $0.size.equalTo(20)
        }
    }
    
    private func setPageViewController() {
        let redVC = PostsViewController(viewModel: PostsViewModel())
        let ornageVC = ColorViewController(color: .orange)
        let yellowVC = ColorViewController(color: .yellow)
        let greenVC = ColorViewController(color: .green)
        let blueVC = ColorViewController(color: .blue)
        let purpleVC = ColorViewController(color: .purple)
        let blackVC = ColorViewController(color: .black)
        dataSourceViewController = [redVC,
                                    ornageVC,
                                    yellowVC,
                                    greenVC,
                                    blueVC,
                                    purpleVC,
                                    blackVC]
    }
    
    private func changeViewController(before beforeIndex: Int, after newIndex: Int) {
        let direction: UIPageViewController.NavigationDirection = beforeIndex < newIndex ? .forward : .reverse
        pageViewController.setViewControllers([dataSourceViewController[currentPage]], direction: direction, animated: true, completion: nil)
        menuBar.isSelected = newIndex
    }
    
    //MARK: - Action Method
    
}

extension HomeViewController: HomeMenuBarDelegate {
    func menuBar(didSelectItemAt indexPath: IndexPath) {
        currentPage = indexPath.row
        
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
        guard previousIndex >= 0 else { return nil }
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
        currentPage = currentIndex
    }
}