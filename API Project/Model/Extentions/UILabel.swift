//
//  UILabel.swift
//  API Project
//
//  Created by Roman on 08.10.2021.
//

import UIKit

extension UILabel {
    convenience init(text: String, alignment: NSTextAlignment = .left) {
        self.init()
        self.text = text
        self.textColor = .black
        self.textAlignment = alignment
        self.adjustsFontSizeToFitWidth = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
