//
//  StorageView.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/05/04.
//

import UIKit

import SnapKit

final class StorageView: BaseUIView {
    
    let listTableView = StorageTableView(frame: .null, style: .insetGrouped)
    let storageHeadView = StorageHeadView()
    let storageViewExceptionView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.emptyPostsList
        imageView.isHidden = true
        return imageView
    }()
    
    override func render() {
        self.addSubviews(
            storageHeadView,
            listTableView,
            storageViewExceptionView
        )
        
        storageHeadView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(156)
        }
        
        listTableView.snp.makeConstraints {
            $0.top.equalTo(storageHeadView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        storageViewExceptionView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(166)
            $0.width.equalTo(150)
        }
    }
    
    func storageTableViewStartScroll() {
        UIView.animate(withDuration: 4, animations: {
            self.storageHeadView.snp.remakeConstraints {
                $0.top.equalToSuperview()
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(116)
            }
            self.storageHeadView.gray100View.snp.remakeConstraints {
                $0.top.equalTo(self.storageHeadView.lineView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(0)
            }
            self.storageHeadView.changeFolderNameButton.isHidden = true
            self.storageHeadView.deleteFolderButton.isHidden = true
        }, completion: { isCompleted in
            self.layoutIfNeeded()
        })
    }
    
    func storageTableViewEndScroll(
        isAllpostFolder: Bool
    ) {
        UIView.animate(withDuration: 4, animations: {
            self.storageHeadView.snp.remakeConstraints {
                $0.top.equalToSuperview()
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(156)
            }
            self.storageHeadView.gray100View.snp.remakeConstraints {
                $0.top.equalTo(self.storageHeadView.lineView.snp.bottom)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(40)
            }
            if !isAllpostFolder {
                self.storageHeadView.changeFolderNameButton.isHidden = false
                self.storageHeadView.deleteFolderButton.isHidden = false
            }
        }, completion: { isCompleted in
            self.layoutIfNeeded()
        })
    }
}
