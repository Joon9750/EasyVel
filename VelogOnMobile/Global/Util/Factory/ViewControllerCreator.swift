//
//  ViewControllerCreator.swift
//  VelogOnMobile
//
//  Created by 장석우 on 2023/06/02.
//

import UIKit

protocol ViewControllerCreator: AnyObject {
    func createViewController() -> UIViewController
}
