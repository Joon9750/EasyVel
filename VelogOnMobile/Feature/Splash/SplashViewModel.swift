//
//  SplashViewModel.swift
//  VelogOnMobile
//
//  Created by 장석우 on 2023/07/07.
//

import Foundation

import RxCocoa
import RxSwift

//MARK: - [Clean Architecture] Presentation Layer

final class SplashViewModel: BaseViewModel {
    
    //MARK: - Properties
    
    private let useCase: SplashUseCase
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let successAutoLogin =  PublishRelay<Bool>()
    }
    
    //MARK: - Life Cycle
    
    init(useCase: SplashUseCase) {
        self.useCase = useCase
    }
    
    //MARK: - Transform
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .subscribe(onNext: { [weak self] in
                self?.useCase.autoLogin()
                    .subscribe(onNext: { isSuccess in
                        output.successAutoLogin.accept(isSuccess)
                    }, onError: { error in
                        guard let error = error as? AuthError else { return }
                        print("⚠️⚠️\(error.description)⚠️⚠️")
                        output.successAutoLogin.accept(false)
                    })
                    .disposed(by: disposeBag)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
}
