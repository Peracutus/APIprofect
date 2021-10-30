//
//  UITextField.swift
//  API Project
//
//  Created by Roman on 08.10.2021.
//

import UIKit

extension UITextField {
    convenience init(placeholder: String) {
        self.init()
        self.clipsToBounds = true
        self.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.borderStyle = .roundedRect
        self.placeholder = placeholder
        self.borderStyle = .roundedRect
        self.keyboardType = .numbersAndPunctuation
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
