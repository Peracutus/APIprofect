//
//  AlertView.swift
//  API Project
//
//  Created by Roman on 10.10.2021.
//

import UIKit

extension UIViewController {
    func alertForButton(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(ok)
        
        present(alert, animated: true, completion: nil)
    }
}
