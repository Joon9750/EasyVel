//
//  SignUpViewController.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//
//  Velog_Signview
//
//  Created by JuHyeonAh on 2023/05/14.
//

import UIKit
import SnapKit

class SignUpViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign up"
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 25)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "ㆍ이름"
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 13)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "ㆍ이메일"
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 13)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let pwLabel: UILabel = {
        let label = UILabel()
        label.text = "ㆍ 비밀번호"
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 13)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let pwcheckLabel: UILabel = {
        let label = UILabel()
        label.text = "ㆍ 비밀번호 확인"
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 13)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = " 이름"
        textField.font = UIFont(name: "Apple SD Gothic Neo", size: 13)
        textField.clearButtonMode = .whileEditing
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 4
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = " 이메일"
        textField.font = UIFont(name: "Apple SD Gothic Neo", size: 13)
        textField.clearButtonMode = .whileEditing
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 4
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let pwTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = " 비밀번호"
        textField.font = UIFont(name: "Apple SD Gothic Neo", size: 13)
        textField.clearButtonMode = .whileEditing
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 4
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let pwcheckTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = " 비밀번호 확인"
        textField.font = UIFont(name: "Apple SD Gothic Neo", size: 13)
        textField.clearButtonMode = .whileEditing
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 4
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.titleLabel?.font = UIFont(name: "Apple SD Gothic Neo", size: 18)
        button.backgroundColor = .init(_colorLiteralRed: 0.118, green: 0.784, blue: 0.592, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self,
                         action: #selector(signupcomButtonTapped),
                         for: .touchUpInside)
        return button
    }()
    
    let stackViewSignup: UIStackView = {
        
        let stackView = UIStackView()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    let stackViewSignUp: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 26
        stackView.distribution = .equalSpacing
        
        return stackView
    }()




    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        set()
        setLayout()
        
    }
    
    func backToSigninViewController() {
            
            let signinViewController = SignInViewController()
            signinViewController.modalPresentationStyle = .fullScreen
            self.present(signinViewController, animated: true)
        }
    
    @objc
    func signupcomButtonTapped() {
        
        backToSigninViewController()
    }
    


}


private extension SignUpViewController {
    
    func set() {
        
        view.backgroundColor = .white
    }
    
    func setLayout() {
        
        view.addSubview(titleLabel)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(pwLabel)
        view.addSubview(pwTextField)
        view.addSubview(pwcheckLabel)
        view.addSubview(pwcheckTextField)
        view.addSubview(signupButton)
        
        titleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(100)
            $0.leading.equalToSuperview().offset(146)
            $0.trailing.equalToSuperview().offset(-146)
        }
        
        nameLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(70)
            $0.leading.equalToSuperview().offset(38)
            $0.height.equalTo(16)
        }
        
        nameTextField.snp.makeConstraints{
            $0.top.equalTo(nameLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(38)
            $0.trailing.equalToSuperview().offset(-38)
            $0.height.equalTo(45)
        }
        
        emailLabel.snp.makeConstraints{
            $0.top.equalTo(nameTextField.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(38)
            $0.height.equalTo(16)
        }
        
        emailTextField.snp.makeConstraints{
            $0.top.equalTo(emailLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(38)
            $0.trailing.equalToSuperview().offset(-38)
            $0.height.equalTo(45)
        }
        pwLabel.snp.makeConstraints{
            $0.top.equalTo(emailTextField.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(38)
            $0.height.equalTo(16)
        }
        
        pwTextField.snp.makeConstraints{
            $0.top.equalTo(pwLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(38)
            $0.trailing.equalToSuperview().offset(-38)
            $0.height.equalTo(45)
        }
        pwcheckLabel.snp.makeConstraints{
            $0.top.equalTo(pwTextField.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(38)
            $0.height.equalTo(16)
        }
        pwcheckTextField.snp.makeConstraints{
            $0.top.equalTo(pwcheckLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(38)
            $0.trailing.equalToSuperview().offset(-38)
            $0.height.equalTo(45)
        }
        
        signupButton.snp.makeConstraints{
            $0.top.equalTo(pwcheckTextField.snp.bottom).offset(60)
            $0.leading.equalToSuperview().offset(38)
            $0.trailing.equalToSuperview().offset(-38)
            $0.height.equalTo(46)
        }
        
    }
}
