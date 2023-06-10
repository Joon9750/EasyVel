//
//  RxBaseViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/14.
//

import UIKit

import RxSwift

public class RxBaseViewController<VM: BaseViewBindable>: UIViewController {

    var isScrapButtonTapped: Bool = false
    var isSubscribeButtonTapped: Bool = false
    
    private let scrapButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        button.setImage(ImageLiterals.unSaveBookMarkIcon, for: .normal)
        return button
    }()
    private let subscriberButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 32)
        button.setTitle("구독", for: .normal)
        button.setTitleColor(UIColor.brandColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Black", size: 14)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.brandColor.cgColor
        button.layer.cornerRadius = 8
        return button
    }()
    lazy var firstButton = UIBarButtonItem(customView: self.scrapButton)
    lazy var secondButton = UIBarButtonItem(customView: self.subscriberButton)
    
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
        navigationItem.rightBarButtonItems = [firstButton, secondButton]
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
        
        scrapButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.isScrapButtonTapped.toggle()
                guard let isScrapButtonTapped = self?.isScrapButtonTapped else { return }
                let image = isScrapButtonTapped ? ImageLiterals.saveBookMarkIcon : ImageLiterals.unSaveBookMarkIcon
                self?.scrapButton.setImage(image, for: .normal)
            })
            .disposed(by: disposeBag)
        
        subscriberButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.isSubscribeButtonTapped.toggle()
                guard let isSubsribeButtonTapped = self?.isSubscribeButtonTapped else { return }
                if isSubsribeButtonTapped {
                    self?.subscriberButton.setTitleColor(UIColor.white, for: .normal)
                    self?.subscriberButton.backgroundColor = .brandColor
                } else {
                    self?.subscriberButton.setTitleColor(UIColor.brandColor, for: .normal)
                    self?.subscriberButton.backgroundColor = .white
                }
            })
            .disposed(by: disposeBag)
    }

    deinit {}
}
