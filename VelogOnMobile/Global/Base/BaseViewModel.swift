//
//  BaseViewModel.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/14.
//

import Foundation

import RxCocoa
import RxSwift

public protocol BaseViewBindable {
    var viewDidLoad: PublishRelay<Void> { get }
    var viewWillAppear: PublishRelay<Void> { get }
    var viewDidAppear: PublishRelay<Void> { get }
    var viewWillDisappear: PublishRelay<Void> { get }
    var viewDidDisappear: PublishRelay<Void> { get }
    var disposeBag: DisposeBag { get }
}

public class BaseViewModel: BaseViewBindable {
    public let viewDidLoad = PublishRelay<Void>()
    public let viewWillAppear = PublishRelay<Void>()
    public let viewDidAppear = PublishRelay<Void>()
    public let viewWillDisappear = PublishRelay<Void>()
    public let viewDidDisappear = PublishRelay<Void>()
    public let finishForPop = PublishRelay<Void>()
    public let finishForDismiss = PublishRelay<Void>()
    public let disposeBag = DisposeBag()

    public init() {}

    deinit {}
}
