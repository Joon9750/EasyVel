//
//  ViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//
//  Created by JuHyeonAh on 2023/05/14.
//

import UIKit
import SnapKit

class SignInViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Login"
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 30)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let idTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "   아이디"
        textField.font = UIFont(name: "Apple SD Gothic Neo", size: 14)
        textField.layer.cornerRadius = 4
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "   비밀번호"
        textField.font = UIFont(name: "Apple SD Gothic Neo", size: 14)
        textField.layer.cornerRadius = 4
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = UIFont(name: "Apple SD Gothic Neo", size: 17)
        button.layer.cornerRadius = 4
        button.backgroundColor = .init(_colorLiteralRed: 0.118, green: 0.784, blue: 0.592, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private lazy var signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.titleLabel?.font = UIFont(name: "Apple SD Gothic Neo", size: 13)
        button.backgroundColor = .white
        button.setTitleColor(.darkGray, for: .normal)
        button.addTarget(self,
                         action: #selector(signupButtonTapped),
                         for: .touchUpInside)
        return button
    }()
    
    private let findidButton: UIButton = {
        let button = UIButton()
        button.setTitle("아이디 / 비밀번호 찾기", for: .normal)
        button.titleLabel?.font = UIFont(name: "Apple SD Gothic Neo", size: 13)
        button.backgroundColor = .white
        button.setTitleColor(.darkGray, for: .normal)
//        button.addTarget(self,
//                         action: #selector(findidButtonTapped),
//                         for: .touchUpInside)
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        set()
        setLayout()
        
    }
    
    func moveToSignUpViewController() {
    
    let signupViewController = SignUpViewController()
    signupViewController.modalPresentationStyle = .fullScreen
    self.present(signupViewController, animated: true)
}
//    func moveToFindIDViewController() {
//
//    let findidViewController = FindIDViewController()
//    findidViewController.modalPresentationStyle = .fullScreen
//    self.present(findidViewController, animated: true)
//}
    @objc
    func signupButtonTapped() {
        
        moveToSignUpViewController()
    }
    
//    @objc
//    func findidButtonTapped() {
//
//        moveToFindIDViewController()
//    }

}

//func moveToFindIDViewController() {
//
//let findIDViewConroller = SignupViewController()
//signupViewController.modalPresentationStyle = .fullScreen
//self.present(signupViewController, animated: true)
//}
//
//@objc
//func signupButtonTapped() {
//
//    FindIDViewController()
//}



private extension SignInViewController {
    
    func set() {
        
        view.backgroundColor = .white
        
    }
    
    func setLayout() {
        
        view.addSubview(titleLabel)
        view.addSubview(idTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(signupButton)
        view.addSubview(findidButton)
        
        titleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(30)
            $0.centerX.equalToSuperview()
        }
        
        idTextField.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(60)
            $0.trailing.equalToSuperview().offset(-60)
            $0.height.equalTo(40)
        }
        
        passwordTextField.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(idTextField.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(60)
            $0.trailing.equalToSuperview().offset(-60)
            $0.height.equalTo(40)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(60)
            $0.trailing.equalToSuperview().offset(-59)
            $0.height.equalTo(46)

        }
        
        signupButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(115)
            $0.bottom.equalToSuperview().offset(-340)
        }
        findidButton.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(15)
            $0.leading.equalTo(signupButton.snp.trailing).offset(20)
            $0.bottom.equalToSuperview().offset(-340)
        }

        
    }
}



