//
//  ScrapView.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/28.
//

import UIKit

import SnapKit

final class ScrapPopUpView: BaseUIView {
    
    // MARK: - Properties
    
    var delegate: ScrapPopUpDelegate?
    var storagePost: StoragePost?
    
    // MARK: - UI Components
    
    private let ScrapLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiterals.scrapPopUpViewLeftText
        label.textColor = .black
        label.font = .body_2_M
        return label
    }()
    
    lazy var moveToStorageButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextLiterals.moveToScrapStorageButtonText, for: .normal)
        button.setTitleColor(UIColor.brandColor, for: .normal)
        button.titleLabel?.font = .body_1_B
        button.backgroundColor = .white
        button.makeRoundBorder(cornerRadius: 5, borderWidth: 1, borderColor: .brandColor)
        button.addTarget(self, action: #selector(scrapBookButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var addToFolderButton: UIButton = {
        let button = UIButton()
        button.setTitle(TextLiterals.presentScrapFolderBottomSheetButtonText, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = .body_1_B
        button.backgroundColor = .brandColor
        button.makeRoundBorder(cornerRadius: 5, borderWidth: 1, borderColor: .brandColor)
        button.addTarget(self, action: #selector(folderButtonTapped), for: .touchUpInside)
        return button
    }()

    override func render() {
        self.backgroundColor = .white
    }
    
    override func configUI() {
        self.addSubviews(
            ScrapLabel,
            moveToStorageButton,
            addToFolderButton
        )
        
        ScrapLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(12)
        }
        
        addToFolderButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(9)
            $0.height.equalTo(30)
            $0.width.equalTo(88)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        moveToStorageButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(9)
            $0.height.equalTo(30)
            $0.width.equalTo(72)
            $0.trailing.equalTo(addToFolderButton.snp.leading).offset(-10)
        }
    }
    
    public func getPostData(post: StoragePost) {
        storagePost = post
    }
}

private extension ScrapPopUpView {
    @objc
    func scrapBookButtonTapped() {
        delegate?.scrapBookButtonTapped()
    }
    
    @objc
    func folderButtonTapped() {
        if let post = storagePost {
            delegate?.folderButtonTapped(scrapPost: post)
        }
    }
}
