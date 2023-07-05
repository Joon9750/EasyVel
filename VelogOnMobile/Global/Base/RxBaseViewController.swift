//
//  RxBaseViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/14.
//

import UIKit

import RxSwift
import RxRelay

public class RxBaseViewController<VM: BaseViewBindable>: UIViewController {

    let disposeBag = DisposeBag()
    var viewModel: VM?
    
    private lazy var backButton = UIBarButtonItem(
        image: ImageLiterals.viewPopButtonIcon,
        style: .plain,
        target: self,
        action: #selector(backButtonTapped)
    )
    
    public init(viewModel: VM) {
        super.init(nibName: nil, bundle: nil)
        bind(viewModel: viewModel)
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        render()
        setupNavigationBar()
        setupNavigationPopGesture()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    func configUI() {
        view.backgroundColor = .white
    }
    
    func render() {}
    
    func setupNavigationBar() { 
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.topItem?.title = TextLiterals.noneText
        navigationItem.leftBarButtonItem = backButton
    }
    
    func setupNavigationPopGesture() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    @objc
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func bind(viewModel: VM) {
        self.viewModel = viewModel

        rx.methodInvoked(#selector(UIViewController.viewDidLoad))
            .map { _ in () }
            .bind(to: viewModel.viewDidLoad)
            .disposed(by: disposeBag)

        rx.methodInvoked(#selector(UIViewController.viewWillAppear))
            .map { _ in () }
            .bind(to: viewModel.viewWillAppear)
            .disposed(by: disposeBag)

        rx.methodInvoked(#selector(UIViewController.viewDidAppear))
            .map { _ in () }
            .bind(to: viewModel.viewDidAppear)
            .disposed(by: disposeBag)

        rx.methodInvoked(#selector(UIViewController.viewWillDisappear))
            .map { _ in () }
            .bind(to: viewModel.viewWillDisappear)
            .disposed(by: disposeBag)

        rx.methodInvoked(#selector(UIViewController.viewDidDisappear))
            .map { _ in () }
            .bind(to: viewModel.viewDidDisappear)
            .disposed(by: disposeBag)
        
        viewModel.serverFailOutput
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { isFail in
                if isFail {
                    ServerFailViewController.show()
                }
            })
            .disposed(by: disposeBag)
    }

    deinit {}
}
