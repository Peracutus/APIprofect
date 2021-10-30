//
//  UIButton.swift
//  API Project
//
//  Created by Roman on 09.10.2021.
//

import UIKit

extension UIButton {
    convenience init(color: UIColor,name: String) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = color
        self.setTitle(name, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 23)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
        self.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.titleLabel?.textAlignment = .center
    }
}
