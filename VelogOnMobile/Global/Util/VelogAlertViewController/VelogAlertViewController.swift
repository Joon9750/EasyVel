//
//  VelogAlertViewController.swift
//  VelogOnMobile
//
//  Created by 장석우 on 2023/07/05.
//

import UIKit

import SnapKit

enum AlertType {
    case deleteTag
    case unsubscribe
    case signOut
    case withdrawal
    
    var title: String {
        switch self {
        case .deleteTag:
            return "정말 태그를 삭제하시겠습니까?"
        case .unsubscribe:
            return "정말 팔로우를 취소하시겠습니까?"
        case .signOut:
            return TextLiterals.signOutAlertMessage
        case .withdrawal:
            return TextLiterals.withdrawalAlertMessage
        }
    }
    
    var canel: String {
        switch self {
        case .deleteTag:
            return "취소"
        case .unsubscribe:
            return "아니오"
        case .signOut:
            return "취소"
        case .withdrawal:
            return "아니오"
        }
    }
    
    var yes: String {
        switch self {
        case .deleteTag:
            return "삭제"
        case .unsubscribe:
            return "네"
        case .signOut:
            return "로그아웃"
        case .withdrawal:
            return "회원 탈퇴"
        }
    }
    
}

protocol VelogAlertViewControllerDelegate: AnyObject {
    func yesButtonDidTap(_ alertType: AlertType)
}

final class VelogAlertViewController: UIViewController {
    
    //MARK: - Properties
    
    private var alertType: AlertType
    
    private weak var delegate: VelogAlertViewControllerDelegate?
    
    //MARK: - UI Components
    
    private let alertView = UIView()
    private let dimmedView = UIView()
    private let alertImageView = UIImageView()
    private let titleLabel = UILabel()
    private let cancelButton = UIButton()
    private let yesButton = UIButton()
    
    //MARK: - Life Cycle
    
    init(alertType: AlertType, delegate: VelogAlertViewControllerDelegate) {
        self.alertType = alertType
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        target()
        
        style()
        hierarchy()
        layout()
        updateUI()
    }
    
    //MARK: - Custom Method
    
    private func target() {
        yesButton.addTarget(self, action: #selector(yesButtonDidTap), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
    }
    
    private func style() {
        view.backgroundColor = .clear
        
        
        alertView.backgroundColor = .white
        alertView.makeRounded(radius: 14)
        alertView.alpha = 1
        
        alertImageView.image = ImageLiterals.alertIcon
        alertImageView.contentMode = .scaleAspectFit
        
        dimmedView.backgroundColor = .black
        dimmedView.alpha = 0.45
        
        titleLabel.font = .body_2_M
        titleLabel.textColor = .gray500
        
        cancelButton.backgroundColor = .gray100
        cancelButton.setTitleColor(.gray300, for: .normal)
        cancelButton.titleLabel?.textAlignment = .center
        cancelButton.titleLabel?.font = .body_2_M
        cancelButton.makeRounded(radius: 4)
        
        yesButton.backgroundColor = .brandColor
        yesButton.setTitleColor(.white, for: .normal)
        yesButton.titleLabel?.textAlignment = .center
        yesButton.titleLabel?.font = .body_2_M
        yesButton.makeRounded(radius: 4)
    }
    
    private func hierarchy() {
        view.addSubviews(dimmedView,alertView)
        alertView.addSubviews(alertImageView, titleLabel, cancelButton, yesButton)
    }
    
    private func layout() {
        alertView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(299)
            $0.height.equalTo(180)
        }
        
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
        alertImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(alertImageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(124)
            $0.height.equalTo(40)
        }
        
        yesButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(124)
            $0.height.equalTo(40)
        }
    }
    
    private func updateUI() {
        titleLabel.text = alertType.title
        cancelButton.setTitle(alertType.canel, for: .normal)
        yesButton.setTitle(alertType.yes, for: .normal)
    }
    
    //MARK: - Action Method
    
    @objc func yesButtonDidTap() {
        dismiss(animated: false)
        delegate?.yesButtonDidTap(alertType)
    }
    
    @objc func cancelButtonDidTap() {
        self.dismiss(animated: false)
    }
}

