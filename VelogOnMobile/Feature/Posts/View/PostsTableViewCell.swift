//
//  KeywordsTableViewCell.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/30.
//

import UIKit

import SnapKit
import Kingfisher

final class PostsTableViewCell: BaseTableViewCell {
    
    static let identifier = "PostsTableViewCell"
    
    weak var cellDelegate: PostScrapButtonDidTapped?
    weak var scrapPostAddInFolderDelegate: ScrapPostAddInFolderProtocol?
    var isTapped: Bool = false {
        didSet {
            updateButton()
        }
    }
    var cellIndex: Int?
    var post: PostDTO?
    var url = String()
    
    let imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let title: UILabel = {
        let title = UILabel()
        title.textColor = .gray700
        title.font = .subhead
        return title
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.textColor = .gray500
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.font = .body_1_M
        return textView
    }()

    let date: UILabel = {
        let label = UILabel()
        label.textColor = .gray300
        label.font = .caption_1_M
        return label
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.textColor = .gray300
        label.font = .caption_1_M
        return label
    }()
    
    let scrapButton : UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.bookMark, for: .normal)
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
            $0.height.equalTo(28)
            $0.leading.trailing.equalToSuperview().inset(15)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(3)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(60)
        }
        
        name.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(5)
            $0.height.equalTo(15)
            $0.width.equalTo(120)
            $0.leading.equalToSuperview().inset(15)
        }
        contentView.bringSubviewToFront(name)
        
        date.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(15)
            $0.trailing.equalToSuperview().inset(15)
        }
        contentView.bringSubviewToFront(date)
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
        let image = isTapped ? ImageLiterals.bookMarkFill : ImageLiterals.bookMark
        scrapButton.setImage(image, for: .normal)
    }
    
    @objc
    func scrapButtonTapped(_ sender: UIButton) {
        if !(isTapped) {
            if let scrapPost = post {
                let storagePost = StoragePost(
                    img: scrapPost.img,
                    name: scrapPost.name,
                    summary: scrapPost.summary,
                    title: scrapPost.title,
                    url: scrapPost.url
                )
                NotificationCenter.default.post(
                    name: Notification.Name("ScrapButtonTappedNotification"),
                    object: nil,
                    userInfo: ["data": storagePost]
                )
            }
        }
        guard let post = post else { return }
        let storagePost = StoragePost(
            img: post.img,
            name: post.name,
            summary: post.summary,
            title: post.title,
            url: post.url
        )
        if let index = cellIndex {
            cellDelegate?.scrapButtonDidTapped(
                storagePost: storagePost,
                isScrapped: isTapped,
                cellIndex: index
            )
        }
        self.isTapped.toggle()
    }
}

extension PostsTableViewCell {
    public func binding(model: PostDTO){
        post = model
        title.text = model.title
        name.text = model.name
        date.text = model.date
        url = model.url ?? String()
        textView.text = model.summary
        
        if textView.text == TextLiterals.noneText {
            textView.isHidden = true
        }
        
        if let image = model.img {
            if image == TextLiterals.noneText {
                imgView.isHidden = true
                title.snp.remakeConstraints {
                    $0.top.equalTo(buttonStackView.snp.bottom).offset(15)
                    $0.height.equalTo(45)
                    $0.leading.trailing.equalToSuperview().inset(15)
                }
            } else {
                let url = URL(string: image)
                imgView.kf.setImage(with: url)
            }
        }
        
        guard let tagList = model.tag else { return }
        switch model.tag?.count {
        case 0:
            if let image = model.img {
                if image == TextLiterals.noneText {
                    buttonStackView.isHidden = true
                    title.snp.remakeConstraints {
                        $0.top.equalToSuperview()
                        $0.height.equalTo(45)
                        $0.leading.trailing.equalToSuperview().inset(15)
                    }
                }
            }
        case 1:
            tagFristButtonIsNotHidden(buttonTitle: tagList[0])
        case 2:
            tagFristButtonIsNotHidden(buttonTitle: tagList[0])
            tagSecondButtonIsNotHidden(buttonTitle: tagList[1])
        case 3:
            tagFristButtonIsNotHidden(buttonTitle: tagList[0])
            tagSecondButtonIsNotHidden(buttonTitle: tagList[1])
            tagThirdButtonIsNotHidden(buttonTitle: tagList[2])
        default:
            tagFristButtonIsNotHidden(buttonTitle: tagList[0])
            tagSecondButtonIsNotHidden(buttonTitle: tagList[1])
            tagThirdButtonIsNotHidden(buttonTitle: tagList[2])
        }
    }
    
    override func prepareForReuse() {
        imgView.isHidden = false
        textView.isHidden = false
        buttonStackView.isHidden = false

        title.snp.remakeConstraints {
            $0.top.equalTo(imgView.snp.bottom).offset(15)
            $0.height.equalTo(45)
            $0.leading.trailing.equalToSuperview().inset(15)
        }
    }
}
