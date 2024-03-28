//
//  VerificationCodeCell.swift
//  EffectiveMobile_TestTask
//
//  Created by Vyacheslav on 28.03.2024.
//

import UIKit

class VerificationCodeCell: UICollectionViewCell {

    @IBOutlet private weak var codeVerificationInput: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        codeVerificationInput.layer.borderWidth = 1
        codeVerificationInput.layer.borderColor = UIColor.clear.cgColor
        codeVerificationInput.layer.cornerRadius = 5
        codeVerificationInput.backgroundColor = .darkGray
    }

}
