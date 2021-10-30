//
//  UIStackView.swift
//  API Project
//
//  Created by Roman on 08.10.2021.
//

import UIKit

extension UIStackView {
    convenience init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat, distribution: UIStackView.Distribution) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        self.alignment = .fill
        self.distribution = distribution
        self.translatesAutoresizingMaskIntoConstraints = true
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
