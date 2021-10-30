//
//  UserManager.swift
//  API Project
//
//  Created by Roman on 10.10.2021.
//

import Foundation

class DataBase {
    
    static let shared = DataBase()
    
    enum SettingKey: String {
        case users
        case activeUser
    }
    
    let dafaults = UserDefaults.standard
    let userKey = SettingKey.users.rawValue
    let activeUserKey = SettingKey.activeUser.rawValue
    var users: [User] {
        
        get {
            if let data = dafaults.value(forKey: userKey) as? Data {
                return try! PropertyListDecoder().decode([User].self, from: data)
            } else {
                return [User]()
            }
        }
        
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                dafaults.set(data, forKey: userKey)
            }
        }
    }
    
    func saveUser(firstName: String, secondName:String, phone: String, email: String, password: String, age:Date) {
        let user = User(firstName: firstName, secondName: secondName, phoneNumber: phone, email: email, password: password, age: age)
        users.insert(user, at: 0)
    }
    
    var activeUser: User? {
        
        get {
            if let data = dafaults.value(forKey: activeUserKey) as? Data {
                return try! PropertyListDecoder().decode(User.self, from: data)
            } else {
                return nil
            }
        }
        
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                dafaults.set(data, forKey: activeUserKey)
            }
        }
    }
    
    func saveActiveUser(user: User) {
        activeUser = user
    }
}
