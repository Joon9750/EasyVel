//
//  ServerFailView.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/06/27.
//

import UIKit

import SnapKit

final class ServerFailViewController: BaseViewController {
    
    let serverFailImage: UIImageView = UIImageView(image: ImageLiterals.serverFailImage)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func render() {
        view.addSubview(serverFailImage)
        
        serverFailImage.snp.makeConstraints {
            $0.height.equalTo(220)
            $0.width.equalTo(180)
            $0.center.equalToSuperview()
        }
    }
    
    override func configUI() {
        view.backgroundColor = .gray100
    }
    
    static func show(from viewController: UIViewController) {
        let serverFailVC = ServerFailViewController()
        viewController.navigationController?.pushViewController(serverFailVC, animated: true)
    }
}
