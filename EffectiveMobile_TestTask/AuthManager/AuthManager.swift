//
//  AuthManager.swift
//  EffectiveMobile_TestTask
//
//  Created by Vyacheslav on 27.03.2024.
//

import Foundation

// MARK: - AuthManager class
class AuthManager {
    
    static let shared = AuthManager()
    
    var isLoggedIn: Bool? {
        UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    func login() {
        UserDefaults.standard.setValue(true, forKey: "isLoggedIn")
        print("u logged in ")
    }
}
