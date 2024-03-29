//
//  ViewVisibilityDelegate.swift
//  EffectiveMobile_TestTask
//
//  Created by Vyacheslav on 29.03.2024.
//

import Foundation

///This protocol is using for displaying auth and verification view if user isn't logged in yet
protocol ViewVisibilityDelegate: AnyObject {

    ///Method calls actonHandlers for make action by tap to buttons
    func actionHandlers()
    
    ///Method  checks is user logged in or not
    func isLoggedIn()
    
    ///Method  setups verificationview at the start of the app
    func setupVerificationView()
    
    ///Method  shows or hides Root view by status
    func showViewByStatus(status: ViewVisibilityStatus)
}
