//
//  ListViewModel.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/30.
//

import UIKit

protocol ListViewModelInput {
    func viewWillAppear()
}

protocol ListViewModelOutput {
    var tagListOutput: ((TagListModel) -> Void)? { get set }
    var subscriberListOutput: ((SubscriberListModel) -> Void)? { get set }
}

protocol ListViewModelInputOutput: ListViewModelInput, ListViewModelOutput {}

final class ListViewModel: ListViewModelInputOutput {
    
    var tagList: TagListModel? {
        didSet {
            if let tagListOutput,
               let tagList {
                tagListOutput(tagList)
            }
        }
    }
    
    var subscriberList: SubscriberListModel? {
        didSet {
            if let subscriberListOutput,
               let subscriberList {
                subscriberListOutput(subscriberList)
            }
        }
    }
    
    // MARK: - Output
    
    var tagListOutput: ((TagListModel) -> Void)?
    var subscriberListOutput: ((SubscriberListModel) -> Void)?
}

// MARK: - Input

extension ListViewModel {
    func viewWillAppear() {
        var tagList = TagListModel()
        var subscriberList = SubscriberListModel()
        self.tagList = tagList
        self.subscriberList = subscriberList
    }
}
