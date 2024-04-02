//
//  UITextView+Extension.swift
//  EffectiveMobile_TestTask
//
//  Created by Vyacheslav on 02.04.2024.
//

import UIKit

extension UITextView {
    
    func adjustUITextViewHeight() {
        self.sizeToFit()
        self.isScrollEnabled = false
    }
    
}
