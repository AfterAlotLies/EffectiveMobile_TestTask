//
//  AuthViewDelegate.swift
//  EffectiveMobile_TestTask
//
//  Created by Vyacheslav on 27.03.2024.
//

import Foundation

///This protocol is using for active or deactivate confirm button
protocol AuthViewDelegate: AnyObject {
    
    ///Method activating button for actions
    func buttonActivate()
    
    ///Method deactivating button so user can't use it
    func buttonDeactivate()
    
    ///Method setting entered userm email in auth view
    func setUserEmail(emailAddress: String)
}

extension AuthViewDelegate {
    
    func buttonActivate() {}
    
    func buttonDeactivate() {}
    
    func setUserEmail(emailAddress: String) {}
}
