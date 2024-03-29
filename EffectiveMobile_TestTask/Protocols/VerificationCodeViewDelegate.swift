//
//  VerificationCodeViewDelegate.swift
//  EffectiveMobile_TestTask
//
//  Created by Vyacheslav on 28.03.2024.
//

import Foundation

///This protocol is using for auto moving cursor to next UITextField + to check if UITextField is last + deactivate confirm button
protocol VerificationCodeViewDelegate: AnyObject {
    
    ///Method  move cursor to next UITextField
    func switchTextField(in cell: VerificationCodeCell)
    
    ///Method  checking is UITextField last
    func isLastEmpty(text: String)
    
    ///Method deactivating confirm button
    func deactivateConfirmButton()
}
