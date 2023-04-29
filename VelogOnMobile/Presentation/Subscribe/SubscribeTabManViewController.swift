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

class SubscribeTabManViewController: TabmanViewController {

    private let finalView = UIView()
    private let tabManBarView = UIView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Subscribe"
        label.font = UIFont(name: "Avenir-Black", size: 30)
        return label
    }()
    private let bar = TMBar.ButtonBar()
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.addButtonIcon, for: .normal)
        button.addTarget(self, action: #selector(addSubscribe), for: .touchUpInside)
        return button
    }()
    private var viewControllers: Array<UIViewController> = [SubscribePostsViewController(), SubscriberListViewController()]

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        bounces = false
        
        setUI()
        settingTabBar(ctBar: bar)
    }
    
    func setUI(){
        
        finalView.addSubviews(
            titleLabel,
            addButton,
            tabManBarView
        )
        
        addBar(bar, dataSource: self, at: .custom(view: tabManBarView, layout: .none))
        
        view.addSubview(finalView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        addButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(30)
            $0.height.width.equalTo(20)
        }
        
        tabManBarView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.width.equalTo(UIScreen.main.bounds.width - 50)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        finalView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(120)
        }
    }
    
    func settingTabBar(ctBar: TMBar.ButtonBar) {
        ctBar.layout.transitionStyle = .snap
        ctBar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 40.0, bottom: 0.0, right: 0.0)
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
    
    @objc func addSubscribe(){
        let nextVC = SubscriberSearchViewController()
        nextVC.modalPresentationStyle = .pageSheet
        if let sheet = nextVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        self.present(nextVC, animated: true)
    }
}

extension SubscribeTabManViewController: PageboyViewControllerDataSource, TMBarDataSource {
  func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
      switch index {
      case 0:
          return TMBarItem(title: "Following Post")
      case 1:
          return TMBarItem(title: "Following List")
      default:
          let title = "Page \(index)"
          return TMBarItem(title: title)
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
