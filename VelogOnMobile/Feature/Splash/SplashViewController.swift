//
//  SplashViewController.swift
//  VelogOnMobile
//
//  Created by 장석우 on 2023/07/07.
//

import UIKit

import RxSwift
import RxCocoa

import SnapKit

//MARK: - [Clean Architecture] Presentation Layer

final class SplashViewController: RxBaseViewController<SplashViewModel> {
    
    //MARK: - UI Components
    
    private let imageView = UIImageView(image: ImageLiterals.signInViewImage)
    
    //MARK: - UI & Layout
    
    override func configUI() {
        view.backgroundColor = .brandColor
        
        imageView.contentMode = .scaleAspectFit
        
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-70)
            $0.width.equalTo(165)
            $0.height.equalTo(204)
        }
    }
    
    //MARK: - Bind
    
    override func bind(viewModel: SplashViewModel) {
        super.bind(viewModel: viewModel)
        
        let input = SplashViewModel.Input(
            viewDidAppear:
                self.rx.methodInvoked(#selector(UIViewController.viewDidAppear)).map { _ in }
        )
        
        let output = self.viewModel?.transform(from: input, disposeBag: disposeBag)
        bindOutput(output)
    }
    
    private func bindOutput(_ output: SplashViewModel.Output?) {
        output?.successAutoLogin
            .asDriver(onErrorJustReturn: Bool())
            .drive(onNext: { isSuccess in
                if isSuccess {
                    let tabVC = TabBarController()
                    let tabNVC = UINavigationController(rootViewController: tabVC)
                    UIApplication.shared.changeRootViewController(tabNVC)
                } else {
                    let signInVM = SignInViewModel()
                    let signInVC = SignInViewController(viewModel: signInVM)
                    let signInNVC = UINavigationController(rootViewController: signInVC)
                    UIApplication.shared.changeRootViewController(signInNVC)
                }
            })
            .disposed(by: disposeBag)
    }
    
    
}
