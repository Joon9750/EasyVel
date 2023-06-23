//
//  TextLiterals.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//

import UIKit

enum TextLiterals {
    
    static let noneText: String = ""
    
    // MARK: - Home
    
    static let homeViewControllerHeadTitle: String = "Home"
    
    // MARK: - storage
    
    static let deleteButtonTitle: String = "Edit"
    static let doneButtonTitle: String = "Done"
    static let headViewTitle: String = "Storage"
    
    // MARK: - tab Bar
    
    static let homeViewControllerTitle: String = "홈"
    static let listViewControllerTitle: String = "팔로우"
    static let storageViewControllerTitle: String = "스크랩"
    static let settingViewControllerTitle: String = "설정"
    
    // MARK: - tag search
    
    static let addTagSuccessText: String = "키워드가 추가되었습니다."
    static let addTagRequestErrText: String = "이미 추가된 관심 키워드입니다."
    static let tagTitleLabelText: String = "Add Keyword"
    static let textFieldPlaceholderText: String = "키워드를 입력해주세요."
    
    // MARK: - subscriber search
    
    static let searchSubscriberIsNotValidText: String = "없는 팔로우입니다. 다시 검색해주세요."
    static let addSubsriberSuccessText: String = "구독자 추가되었습니다."
    static let addSubscriberRequestErrText: String = "이미 추가한 팔로우입니다. 다시 검색해주세요."
    static let subscriberSearchTitleLabelText: String = "Search Subscribers"
    static let subscriberSearchTextFieldPlaceholderText: String = "velog 아이디를 입력해주세요."
    
    // MARK: - button label
    
    static let addButtonText: String = "Add"
    static let dismissButtonText: String = "dismiss"
    
    // MARK: - posts tabMan
    
    static let postTabManTitleLabelText: String = "Posts"
    static let notifiButtonText: String = "Alarm"
    static let postTabManKeywordPostsTitleText: String = "Keyword Posts"
    static let postTabManSubscriberPostsTitleText: String = "Subscriber Posts"
    
    // MARK: - keyword posts
    
    static let addToastText: String = "추가되었습니다."
    static let alreadyAddToastText: String = "이미 스크랩한 글입니다."
    
    // MARK: - list
    
    static let listKeywordText: String = "Keywords"
    static let listSubscriberText: String = "Subscribers"
    static let listKeywordActionSheetTitleText: String = "Keyword"
    static let listSubscriberActionSheetTitleText: String = "Subscriber"
    static let listActionSheetCancelText: String = "Cancel"
    static let listAlertControllerTitleText: String = "추가"
    static let listAlertControllerMessageText: String = "추가할 기준을 선택해주세요."
    static let listTitleLabelText: String = "Follow"
    
    // MARK: - setting
    
    static let settingTitleLabelText: String = "Setting"
    static let settingAlertText: String = "구독 알림"
    static let settingSignOutText: String = "로그아웃"
    static let settingWithdrawalText: String = "회원탈퇴"
    static let settingChangeEmailText: String = "이메일 변경"
    static let settingChangePasswordText: String = "비밀번호 변경"
    
    // MARK: - table view
    
    static let tableViewDeleteSwipeTitle: String = "delete"
    
    // MARK: - navigation bar
    
    static let addSubscriberToastText:String = "팔로우 했습니다."
    static let deleteSubscriberToastText: String = "팔로우 취소 했습니다."
    static let navigationBarSubscribeButtonText: String = "팔로우"
    
    // MARK: - velog url
    
    static let velogBaseURL: String = "https://velog.io"
    
    // MARK: - scrap folder
    
    static let allPostsScrapFolderText: String = "모든 게시글"
    
    // MARK: - scrap PopUp view
    
    static let scrapPopUpViewLeftText: String = "스크랩했습니다."
    static let moveToScrapStorageButtonText: String = "보러가기"
    static let presentScrapFolderBottomSheetButtonText: String = "폴더에 담기"
    
    // MARK: - scrapFolderBottomSheet
    
    static let bottomSheetText: String = "폴더 선택"
    static let makeNewFolderButtonText: String = "새 폴더 만들기"
    static let newFolderAddTextFieldPlaceholder: String = "폴더명을 입력하세요."
    static let addFolderFinishedButtonTitleText: String = "완료"
    
    // MARK: - scrap storage view
    
    static let scrapStorageTitleLabel: String = "Scrap"
    static let addFolderAlertTitle: String = "폴더 추가"
    static let addFolderAlertOkActionTitle: String = "확인"
    static let addFolderAlertCancelActionTitle: String = "취소"
    static let alreadyHaveFolderToastText: String = "이미 존재하는 폴더명입니다."
    static let addFolderButtonTitle: String = "폴더 추가"
    static let postInFolderCountText: String = "개"
    
    // MARK: - storage view
    
    static let deleteFolderActionSheetTitle: String = "폴더 삭제"
    static let deleteFolderActionSheetMessage: String = "선택하신 폴더를 정말 삭제하시겠습니까?\n스크랩한 콘텐츠가 모두 삭제됩니다."
    static let deleteFolderActionSheetOkActionText: String = "삭제"
    static let deleteFolderActionSheetCancelActionText: String = "취소"
    
    static let folderNameChangeSuccessToastText: String = "폴더명이 변경되었습니다."
    static let folderNameChangeToastTitle: String = "폴더 이름 변경"
    static let folderNameChangeToastOkActionText: String = "확인"
    static let folderNameChangeToastCancelActionText: String = "취소"
    
    static let storageViewDeleteFolderButtonText: String = "폴더 삭제"
    static let storageViewChangeFolderNameButtonText: String = "이름 변경"
    
    static let storageViewPostDeleteButtonText: String = "삭제"
    
    // MARK: - post search view
    
    static let postSearchViewRecentLabel: String = "최근 검색어"
    static let postSearchViewDeleteAllRecentDataButtonText: String = "모두 지우기"
    static let postSearchViewTrendLabel: String = "인기 키워드"
    
    static let postSearchViewSearchBarPlaceholderText: String = "통합검색"
    
    // MARK: - subscriber list view
    
    static let unSubscriberAlertTitle: String = "팔로우 취소"
    static let unSubscriberAlertMessage: String = "정말 팔로우를 취소하시겠습니까?"
    static let unSubscriberAlertOkActionText: String = "네"
    static let unSubscriberAlertCancelActionText: String = "아니요"
    
    static let subscriberListViewSubTitleLabel: String = "팔로우 중인 사람"
    static let subscriberListViewUnSubscribeButtonText: String = "팔로우 취소"
    
    // MARK: - search subscriber view
    
    static let searchSubscriberTitle: String = "팔로우 추가"
    
    // MARK: - setting view
    
    static let signOutAlertTitle: String = "로그아웃"
    static let signOutAlertMessage: String = "정말 로그아웃 하시겠습니까?"
    
    static let withdrawalAlertTitle: String = "회원탈퇴"
    static let withdrawalAlertMessage: String = "정말 회원탈퇴 하시겠습니까?\n복구하실 수 없습니다."
    
    static let settingAlertOkActionText: String = "네"
    static let settingAlertCancelActionText: String = "아니요"
}
