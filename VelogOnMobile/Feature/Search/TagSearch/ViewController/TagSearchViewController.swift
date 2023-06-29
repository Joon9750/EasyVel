//
//  KeywordSearchViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/30.
//

import UIKit

import RxSwift
import RxCocoa

final class TagSearchViewController: RxBaseViewController<TagSearchViewModel> {
    
    private let searchView = TagSearchView()
    
    //MARK: - Properties
    
    //MARK: - UI Components
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 280, height: 0))
        searchBar.placeholder = TextLiterals.tagSearchPlaceholderText
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
    
    
    //MARK: - Life Cycle

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonAction()
        
        
        hierarchy()
        layout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNaviagtionBar()
        
    }

    override func render() {
        self.view = searchView
    }
    
    //MARK: - Bind
    



//MARK: - Action Method

private extension TagSearchViewController {
    func setButtonAction() {
        searchView.dismissBtn.addTarget(self, action: #selector(dismissButtonAction), for: .touchUpInside)
    }
    
    @objc
    func dismissButtonAction() {
        self.dismiss(animated: true)
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
    }
    
    func layout() {
        
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
