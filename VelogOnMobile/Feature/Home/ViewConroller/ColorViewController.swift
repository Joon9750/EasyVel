//
//  ColorViewController.swift
//  VelogOnMobile
//
//  Created by 장석우 on 2023/06/02.
//

import UIKit

import SnapKit

final class ColorViewController: UIViewController {
    
    //MARK: - Properties
    
    //MARK: - UI Components
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    init(color: UIColor) {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Custom Method
    
    
    func dataBind(color: UIColor) {
        view.backgroundColor = color
    }
    
    //MARK: - Action Method
    
}
