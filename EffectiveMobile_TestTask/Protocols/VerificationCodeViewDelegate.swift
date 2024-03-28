//
//  VerificationCodeViewDelegate.swift
//  EffectiveMobile_TestTask
//
//  Created by Vyacheslav on 28.03.2024.
//

import Foundation

///This protocol is using for auto moving cursor to next UITextField + to check if UITextField is last + deactivate confirm button
protocol VerificationCodeViewDelegate: AnyObject {
    func switchTextField(in cell: VerificationCodeCell)
    func isLastEmpty(text: String)
    func deactivateConfirmButton()
}
