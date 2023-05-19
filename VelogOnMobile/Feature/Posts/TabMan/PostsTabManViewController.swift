//
//  SubscribeTabManViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//

import UIKit

import Tabman
import Pageboy
import SnapKit

final class PostsTabManViewController: TabmanViewController {

    private let finalView = UIView()
    private let tabManBarView = UIView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiterals.postTabManTitleLabelText
        label.font = UIFont(name: "Avenir-Black", size: 30)
        return label
    }()
    private let notifiButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bell")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    private let bar = TMBar.ButtonBar()
    private var keywordsPostsViewModel = KeywordsPostsViewModel()
    private var subscriberPostViewModel = SubscriberPostsViewModel()
    private lazy var keywordsPostsViewController = KeywordsPostsViewController(viewModel: keywordsPostsViewModel)
    private lazy var subscribePostsViewController = SubscribePostsViewController(viewModel: subscriberPostViewModel)
                                                                        
    lazy var viewControllers: Array<UIViewController> = [keywordsPostsViewController, subscribePostsViewController]

    override func viewDidLoad() {
        super.viewDidLoad()
    
        setUI()
        configUI()
        settingTabBar(ctBar: bar)
        settingScrollable()
        setDelegate()
        setNavigationBar()
    }
    
    func setUI(){
        
        finalView.addSubviews(
            titleLabel,
            notifiButton,
            tabManBarView
        )
        
        addBar(bar, dataSource: self, at: .custom(view: tabManBarView, layout: .none))
        
        view.addSubview(finalView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        notifiButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.width.equalTo(35)
        }
        
        tabManBarView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
            $0.width.equalTo(UIScreen.main.bounds.width - 50)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
            $0.bottom.equalTo(finalView.snp.bottom)
        }
        
        view.bringSubviewToFront(tabManBarView)
        
        finalView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(106)
        }
    }
    
    func configUI() {
        finalView.backgroundColor = .white
    }
    
    func settingTabBar(ctBar: TMBar.ButtonBar) {
        ctBar.layout.transitionStyle = .snap
        ctBar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 30.0, bottom: 0.0, right: 0.0)
        ctBar.layout.interButtonSpacing = UIScreen.main.bounds.width - 340
        ctBar.backgroundView.style = .blur(style: .light)
        ctBar.buttons.customize { (button) in
            button.tintColor = UIColor.black
            button.selectedTintColor = .black
            button.font = UIFont.systemFont(ofSize: 16)
            button.selectedFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        }
        ctBar.indicator.weight = .custom(value: 2)
        ctBar.indicator.tintColor = .brandColor
    }
    
    func settingScrollable() {
        self.isScrollEnabled = false
    }
    
    func setDelegate() {
        dataSource = self
        bounces = false
    }
    
    func setNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
}

extension PostsTabManViewController: PageboyViewControllerDataSource, TMBarDataSource {
  func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
      switch index {
      case 0: return TMBarItem(title: TextLiterals.postTabManKeywordPostsTitleText)
      case 1: return TMBarItem(title: TextLiterals.postTabManSubscriberPostsTitleText)
      default: return TMBarItem(title: TextLiterals.noneText)
      }
  }
  
  func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
      return viewControllers.count
  }

  func viewController(for pageboyViewController: PageboyViewController,
                      at index: PageboyViewController.PageIndex) -> UIViewController? {
      return viewControllers[index]
  }

  func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
      return nil
  }
}
