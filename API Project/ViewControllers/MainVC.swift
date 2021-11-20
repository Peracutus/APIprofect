//
//  ViewController.swift
//  API Project
//
//  Created by Roman on 07.10.2021.
//

import UIKit
import EasyPeasy

class MainVC: UIViewController {
    
    //MARK: - Create views
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let generalView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let loginLabel = UILabel(text: "Login", alignment: .center)
    private let emailTextField = UITextField(placeholder: "Enter email")
    private let passwordTextField = UITextField(placeholder: "Enter password")
    private let signInButton = UIButton(color: #colorLiteral(red: 0.4641294958, green: 0.875338346, blue: 0.3624648952, alpha: 1), name: "Sing IN")
    private let signUpButton = UIButton(color: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), name: "Sing UP")
    private var textFieldStackView = UIStackView()
    private var buttonsFieldStackView = UIStackView()
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setConstraints()
        setupDelegate()
        buttonTargets()
        registerKeyboardNotification()
        
    }
    deinit {
        removeKeyboardNotification()
    }
    
    //MARK: - Setup View
    
    private func setupView() {
        textFieldStackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField],
                                         axis: .vertical,
                                         spacing: 10,
                                         distribution: .fillProportionally)
        
        buttonsFieldStackView  = UIStackView(arrangedSubviews: [signInButton,signUpButton],
                                             axis: .horizontal,
                                             spacing: 10,
                                             distribution: .fillEqually)
        
        view.addSubview(scrollView)
        scrollView.addSubview(generalView)
        generalView.addSubview(loginLabel)
        generalView.addSubview(textFieldStackView)
        generalView.addSubview(buttonsFieldStackView)
    }
    
    //MARK: - Set Constraints
    
    private func setConstraints() {
        
        scrollView.easy.layout(Left(),Right(),Top(),Bottom())
        generalView.easy.layout(CenterX(),CenterY(),Height().like(view, .height), Width().like(view, .width))
        
        loginLabel.easy.layout(CenterX(),Top(-30).to(textFieldStackView, .top))
        textFieldStackView.easy.layout(CenterX(),CenterY(),Left(20),Right(20))
        signUpButton.easy.layout(Height(40))
        signInButton.easy.layout(Height().like(signUpButton, .height))
        buttonsFieldStackView.easy.layout(Left(20), Top(30).to(textFieldStackView, .bottom), Right(20))
    }
    
    private func setupDelegate() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    //MARK: - Button actions
    
    private func buttonTargets() {
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
    }
    
    @objc private func signInTapped() {
        
        let mail = emailTextField.text ?? ""
        let pass = passwordTextField.text ?? ""
        let user = findUserDataBase(mail: mail)
        if user == nil {
            loginLabel.text = "User not found"
            loginLabel.textColor = .systemRed
        } else if user?.password == pass {
            let singInVC = UINavigationController(rootViewController: AlbumsVC())
            singInVC.modalPresentationStyle = .fullScreen
            self.present(singInVC, animated: true)
            
            guard let activeUser = user else {return}
            DataBase.shared.saveActiveUser(user: activeUser
            )
        } else {
            loginLabel.text = "Wrong password"
            loginLabel.textColor = .systemRed
        }
//        let singInVC = UINavigationController(rootViewController: AlbumsVC())
//        singInVC.modalPresentationStyle = .fullScreen
//        self.present(singInVC, animated: true)
    }
    
    private func findUserDataBase(mail: String) -> User? {
        let dataBase = DataBase.shared.users
        print(dataBase)
        
        for user in dataBase {
            if user.email == mail {
                return user
            }
        }
        return nil
    }
    
    @objc private func signUpTapped() {
        let signUpVC = SignUpVC()
        self.present(signUpVC, animated: true)
    }
}

//MARK: - UITextFieldDelegate

extension MainVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
}

//MARK: - Up and down view with using Keyboard
extension MainVC {
    private func registerKeyboardNotification() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        let userInfo = notification.userInfo
        let keyboardHeight = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollView.contentOffset = CGPoint(x: 0, y: keyboardHeight.height/2)
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        scrollView.contentOffset = CGPoint.zero
    }
    
    private func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
