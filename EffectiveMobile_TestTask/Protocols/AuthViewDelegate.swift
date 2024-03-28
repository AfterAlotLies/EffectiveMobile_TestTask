//
//  AuthViewDelegate.swift
//  EffectiveMobile_TestTask
//
//  Created by Vyacheslav on 27.03.2024.
//

import Foundation

///This protocol is using for active or deactivate confirm button
protocol AuthViewDelegate: AnyObject {
    func buttonActivate()
    func buttonDeactivate()
}
