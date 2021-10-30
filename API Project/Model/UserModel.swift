//
//  UserModel.swift
//  API Project
//
//  Created by Roman on 10.10.2021.
//

import Foundation

struct User: Codable {
    let firstName: String
    let secondName: String
    let phoneNumber: String
    let email: String
    let password: String
    let age: Date
}
