//
//  RxBaseViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/14.
//

import UIKit

import RxSwift
import SnapKit

public class RxBaseViewController<VM: BaseViewBindable>: UIViewController {

    let disposeBag = DisposeBag()
    var viewModel: VM?

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

    func configUI() {
        view.backgroundColor = .white
    }
    
    func render() {}
    
    func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.topItem?.title = TextLiterals.noneText
    }
    
    func setupNavigationPopGesture() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
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
    }

    deinit {}
}
