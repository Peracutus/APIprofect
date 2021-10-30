//
//  RegistrationVC.swift
//  API Project
//
//  Created by Roman on 08.10.2021.
//

import UIKit
import EasyPeasy

class SignUpVC: UIViewController {
    
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
    
    private let registrationLabel = UILabel(text: "Registration", alignment: .center)
    private let firstNameTextField = UITextField(placeholder: "Enter First Name")
    private let firstNameValidLAbel = UILabel(text: "required field")
    private let secondNameLabel = UILabel(text: "Requaired field")
    private let secondNameTextField = UITextField(placeholder: "Enter Second Name")
    private let ageValidLabel = UILabel(text: "Requaired field")
    private let phoneNumberTextField = UITextField(placeholder: "Enter your phone")
    private let phoneNumberLabel = UILabel(text: "Requaired field")
    private let emailTextField = UITextField(placeholder: "Enter Email")
    private let emailLabel = UILabel(text: "Requaired field")
    private let passwordTextField = UITextField(placeholder: "Enter password")
    private let passwordlLabel = UILabel(text: "Requaired field")
    private let signUpButton = UIButton(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), name: "Sing UP")
    private var datePicker = UIDatePicker()
    private var elementsStackView = UIStackView()
    
    let nameValidType: String.ValidTypes = .name
    let emailValidType: String.ValidTypes = .email
    let passwordValidType: String.ValidTypes = .password
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        registrationLabel.font = UIFont.boldSystemFont(ofSize: 25)
        
        setupView()
        setConstraints()
        setupDelegate()
        setupDatePicker()
        registerKeyboardNotification()
    }
    deinit {
        removeKeyboardNotification()
    }
    
    //MARK: - Setup View
    
    private func setupView() {
        passwordTextField.isSecureTextEntry = true
        
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        
        view.addSubview(scrollView)
        scrollView.addSubview(generalView)
        elementsStackView = UIStackView(arrangedSubviews: [firstNameTextField,
                                                           firstNameValidLAbel,
                                                           secondNameTextField,
                                                           secondNameLabel,
                                                           datePicker,
                                                           ageValidLabel,
                                                           phoneNumberTextField,
                                                           phoneNumberLabel,
                                                           emailTextField,
                                                           emailLabel,
                                                           passwordTextField,
                                                           passwordlLabel],
                                        axis: .vertical,
                                        spacing: 10,
                                        distribution: .fillProportionally)
        generalView.addSubview(elementsStackView)
        generalView.addSubview(registrationLabel)
        generalView.addSubview(signUpButton)
    }
    
    @objc private func signUpTapped() {
        let firstName = firstNameTextField.text ?? ""
        let secondName = secondNameTextField.text ?? ""
        let emailText = emailTextField.text ?? ""
        let passwordText = passwordTextField.text ?? ""
        let phoneNumber = phoneNumberTextField.text ?? ""
        
        if firstName.isValid(validType: nameValidType)
            && secondName.isValid(validType: nameValidType)
            && emailText.isValid(validType: emailValidType)
            && passwordText.isValid(validType: passwordValidType)
            && phoneNumber.count == 18
            && ageIsValid() == true {
            
            DataBase.shared.saveUser(firstName: firstName, secondName: secondName, phone: phoneNumber, email: emailText, password: passwordText, age: datePicker.date)
            
            registrationLabel.text = "Registration complete"
        } else {
            registrationLabel.text = "Registration"
            alertForButton(title: "Error", message: "Fill in all filds")
        }
    }
    
    private func setTextFieldRule(textField: UITextField, label: UILabel, validMessage: String, wrongMessage: String, string: String, range: NSRange, validType: String.ValidTypes) {
        
        let text = (textField.text ?? "") + string
        let result : String
        
        if range.length == 1 {
            let end = text.index(text.startIndex, offsetBy: text.count - 1)
            result = String(text[text.startIndex..<end])
        } else {
            result = text
        }
        
        textField.text = result
        
        
        if result.isValid(validType: validType) {
            label.text = validMessage
            label.textColor = .green
        } else {
            label.text = wrongMessage
            label.textColor = .red
        }
    }
    
    private func setPhoneNumber(textField: UITextField, mask: String, string: String, range: NSRange) -> String {
        let text = textField.text ?? ""
        
        let phoneNumber = (text as NSString).replacingCharacters(in: range, with: string)
        let number = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = number.startIndex
        
        for character in mask where index < number.endIndex {
            if character == "X" {
                result.append(number[index])
                index = number.index(after: index)
            } else {
                result.append(character)
            }
        }
        if result.count == 18 {
            phoneNumberLabel.text = "Phone is valid"
            phoneNumberLabel.textColor = .green
        } else {
            phoneNumberLabel.text = "Phone is not valid"
            phoneNumberLabel.textColor = .red
        }
        return result
    }
    private func ageIsValid()-> Bool {
        let calendar = NSCalendar.current
        let dateNow = Date()
        let birthday = datePicker.date
        
        let age = calendar.dateComponents([.year], from: birthday, to: dateNow)
        let ageYear = age.year
        guard let ageUser = ageYear else {return false}
        return (ageUser<18 ? false: true)
    }
    //MARK: - Set Constraints
    
    private func setConstraints() {
        
        scrollView.easy.layout(Left(),Right(),Top(),Bottom())
        generalView.easy.layout(CenterX(),CenterY(),Height().like(view, .height), Width().like(view, .width))
        
        elementsStackView.easy.layout(CenterX(),CenterY(),Left(20),Right(20))
        registrationLabel.easy.layout(CenterX(),Top(-30).to(elementsStackView, .top))
        signUpButton.easy.layout(CenterX(),Height(40),Width(300),Top(30).to(elementsStackView, .bottom))
    }
    
    private func setupDelegate() {
        firstNameTextField.delegate = self
        secondNameTextField.delegate = self
        phoneNumberTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    
    //MARK: - Date Picker
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.layer.masksToBounds = true
        datePicker.layer.cornerRadius = 6
        datePicker.layer.borderWidth = 1
        datePicker.contentHorizontalAlignment = .left
        datePicker.tintColor = .black
        datePicker.backgroundColor = .white
        datePicker.layer.borderColor = CGColor(gray: 10, alpha: 50)
    }
}

//MARK: - UITextFieldDelegate

extension SignUpVC: UITextFieldDelegate {
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case firstNameTextField: setTextFieldRule(textField: firstNameTextField,
                                                  label: firstNameValidLAbel,
                                                  validMessage: "Name is valid",
                                                  wrongMessage: "Only A-Z characters and min 1 symbol",
                                                  string: string,
                                                  range: range,
                                                  validType: nameValidType)
            
        case secondNameTextField: setTextFieldRule(textField: secondNameTextField,
                                                   label: secondNameLabel,
                                                   validMessage: "Name is valid",
                                                   wrongMessage: "Only A-Z characters and min 1 symbol",
                                                   string: string,
                                                   range: range,
                                                   validType: nameValidType)
            
        case  emailTextField: setTextFieldRule(textField: emailTextField,
                                               label: emailLabel,
                                               validMessage: "Email is valid",
                                               wrongMessage: "Email is not valid",
                                               string: string,
                                               range: range,
                                               validType: emailValidType)
            
        case phoneNumberTextField: phoneNumberTextField.text = setPhoneNumber(textField: phoneNumberTextField,
                                                                              mask: "+X (XXX) XXX-XX-XX",
                                                                              string: string,
                                                                              range: range)
            
        case passwordTextField: setTextFieldRule(textField: passwordTextField,
                                                 label: passwordlLabel,
                                                 validMessage: "Password is valid",
                                                 wrongMessage: "Password is not valid",
                                                 string: string,
                                                 range: range,
                                                 validType: passwordValidType)
            
        default:
            break
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        firstNameTextField.resignFirstResponder()
        secondNameTextField.resignFirstResponder()
        
        return true
    }
}

//MARK: - Up and down view with using Keyboard
extension SignUpVC {
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
