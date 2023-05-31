//
//  ScrapButton.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/30.
//

import UIKit

final class ScrapButton: UIButton {
    
    // MARK: - Properties
    
    var handler: (() -> Void)?
    
    var isTapped: Bool = false {
        didSet {
            updateButton()
        }
    }
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension ScrapButton {
    private func setUI() {
        self.setImage(ImageLiterals.unSaveBookMarkIcon, for: .normal)
//        self.addTarget(self, action: #selector(scrapButtonTapped), for: .touchUpInside)
    }
    
    func updateButton() {
        let image = isTapped ? ImageLiterals.saveBookMarkIcon : ImageLiterals.unSaveBookMarkIcon
        self.setImage(image, for: .normal)
    }
    
    @objc func scrapButtonTapped() {
        if !(isTapped) {
            NotificationCenter.default.post(name: Notification.Name("ScrapButtonTappedNotification"), object: nil)
        }
        self.isTapped.toggle()
        handler?()
    }
}
