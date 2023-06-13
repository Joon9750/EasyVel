//
//  MoveViewController.swift
//  VelogOnMobile
//
//  Created by JuHyeonAh on 2023/06/08.
//
import UIKit

import SnapKit

class MoveViewController: UIViewController {
    
    lazy var button: UIButton = {
        
        let btn = UIButton(frame: CGRect(x: view.frame.width/2 - 75, y: 400, width: 150, height: 50), primaryAction: UIAction(handler: { _ in
                        
            self.navigationController?.pushViewController(SearchViewController(), animated: true)
        }))
        
        btn.setTitle("NextVC", for: .normal)
        btn.backgroundColor = .systemBlue
        
        return btn
        
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        self.view.addSubview(button)
        self.navigationItem.title = "FirstVC"
        
    }
    
}
