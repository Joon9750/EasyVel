//
//  PostTableViewCell.swift
//  VelogOnMobile
//
//  Created by 장석우 on 2023/06/03.
//

import UIKit

import SnapKit
import Kingfisher

final class PostTableViewCell: BaseTableViewCell {
    
    weak var cellDelegate: PostScrapButtonDidTapped?
    var isTapped: Bool = false {
        didSet {
            updateButton()
        }
    }
    
    var post: TagPostDtoList?
    var url = String()
    let imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    let textView: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor.darkGray
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.font = UIFont(name: "Avenir-Black", size: 12)
        return textView
    }()
    let title: UILabel = {
        let title = UILabel()
        title.font = UIFont(name: "Avenir-Black", size: 17)
        return title
    }()
    let date: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Black", size: 10)
        return label
    }()
    let name: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Black", size: 12)
        return label
    }()
    let scrapButton : UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.unSaveBookMarkIcon, for: .normal)
        return button
    }()
    let tagFristButton: PostTagUIButton = PostTagUIButton()
    let tagSecondButton: PostTagUIButton = PostTagUIButton()
    let tagThirdButton: PostTagUIButton = PostTagUIButton()
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 6
        stackView.axis = .horizontal
        return stackView
    }()
    
    // MARK: - life cycle
    
    override func render() {
        self.scrapButton.addTarget(self, action: #selector(scrapButtonTapped), for: .touchUpInside)
        
        self.contentView.addSubviews(
            buttonStackView,
            imgView,
            date,
            name,
            title,
            textView,
            scrapButton
        )
        
        buttonStackView.addArrangedSubviews(
            tagFristButton,
            tagSecondButton,
            tagThirdButton
        )
        contentView.bringSubviewToFront(buttonStackView)
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(12)
        }
        
        scrapButton.snp.makeConstraints {
            $0.height.width.equalTo(32)
            $0.top.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(8)
        }
        contentView.bringSubviewToFront(scrapButton)
        
        imgView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        title.snp.makeConstraints {
            $0.top.equalTo(imgView.snp.bottom).offset(15)
            $0.height.equalTo(45)
            $0.leading.trailing.equalToSuperview().inset(15)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(60)
        }
        
        name.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(15)
            $0.width.equalTo(120)
            $0.leading.equalToSuperview().inset(15)
        }
        
        date.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(15)
            $0.trailing.equalTo(name.snp.trailing).offset(10)
        }
    }
    
    private func tagFristButtonIsNotHidden(buttonTitle: String) {
        tagFristButton.isHidden = false
        tagFristButton.setTitle(buttonTitle, for: .normal)
    }
    
    private func tagSecondButtonIsNotHidden(buttonTitle: String) {
        tagSecondButton.isHidden = false
        tagSecondButton.setTitle(buttonTitle, for: .normal)
    }
    
    private func tagThirdButtonIsNotHidden(buttonTitle: String) {
        tagThirdButton.isHidden = false
        tagThirdButton.setTitle(buttonTitle, for: .normal)
    }
    
    func updateButton() {
        let image = isTapped ? ImageLiterals.saveBookMarkIcon : ImageLiterals.unSaveBookMarkIcon
        scrapButton.setImage(image, for: .normal)
    }
    
    @objc func scrapButtonTapped(_ sender: UIButton) {
        if !(isTapped) {
            NotificationCenter.default.post(name: Notification.Name("ScrapButtonTappedNotification"), object: nil)
        }
        guard let post = post else { return }
        let storagePost = StoragePost(
            img: post.img,
            name: post.name,
            summary: post.summary,
            title: post.title,
            url: post.url
        )
        cellDelegate?.scrapButtonDidTapped(
            storagePost: storagePost,
            isScrapped: isTapped
        )
        self.isTapped.toggle()
    }
}
