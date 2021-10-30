//
//  UserInfoVC.swift
//  API Project
//
//  Created by Roman on 09.10.2021.
//

import UIKit
import EasyPeasy

class UserInfoVC: UIViewController {
    
    private let firstName = UILabel(text: "First name", alignment: .center)
    private let secondName = UILabel(text: "Second Name", alignment: .center)
    private let ageLabel = UILabel(text: "Age", alignment: .center)
    private let phoneLabel = UILabel(text: "Phone", alignment: .center)
    private let emailLabel = UILabel(text: "Email", alignment: .center)
    private let passwordLabel = UILabel(text: "password", alignment: .center)
    
    private var elementsStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setModel()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        elementsStackView = UIStackView(arrangedSubviews: [firstName,
                                                           secondName,
                                                           ageLabel,
                                                           phoneLabel,
                                                           emailLabel,
                                                           passwordLabel],
                                        axis: .vertical,
                                        spacing: 10,
                                        distribution: .fillProportionally)
        view.addSubview(elementsStackView)
        elementsStackView.easy.layout(Left(20),Right(20), CenterY())
    }
    
    private func setModel() {
        guard let activeUser = DataBase.shared.activeUser else {return}
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: activeUser.age)
        firstName.text = activeUser.firstName
        secondName.text = activeUser.secondName
        ageLabel.text = dateString
        phoneLabel.text = activeUser.phoneNumber
        emailLabel.text = activeUser.email
        passwordLabel.text = activeUser.password
    }
}
