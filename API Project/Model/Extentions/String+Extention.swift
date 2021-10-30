//
//  String+Extention.swift
//  API Project
//
//  Created by Roman on 10.10.2021.
//

import Foundation

extension String {
    
    enum ValidTypes {
        case name
        case email
        case password
    }
    
    enum Regex: String {
        case name = "[a-zA-Z]{1,}" //creating regular expressions. In this case it allows us to sorted input parameters by characters a-z and A-Z with minimal interval equal 1 char and max = infinity
        case email = "[a-zA-Z0-9._]{1,}+@[a-z0-9]+\\.[a-z]{2,}"
        case password = "(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{6,}"
    }
    
    func isValid(validType:ValidTypes) -> Bool {
        let format = "SELF MATCHES %@" // in NSPredicate
        // %@ is a var arg substitution for an object value—often a string, number, or date.
        var regex = ""
        
        switch validType {
        case .name: regex = Regex.name.rawValue
        case .email: regex = Regex.email.rawValue
        case .password: regex = Regex.password.rawValue
            
        }
        return NSPredicate(format: format, regex).evaluate(with: self)
    }
}
