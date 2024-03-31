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
    
    ///Method checking is user logged in or not
    func checkRegistrationState()
    
    ///Method  shows or hides Root view by status
    func showViewByStatus(status: ViewVisibilityStatus)
}
