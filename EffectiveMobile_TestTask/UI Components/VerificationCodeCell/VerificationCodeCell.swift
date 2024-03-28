//
//  VerificationCodeCell.swift
//  EffectiveMobile_TestTask
//
//  Created by Vyacheslav on 28.03.2024.
//

import UIKit

//MARK : - VerificationCodeCell class
class VerificationCodeCell: UICollectionViewCell {
    
    @IBOutlet private weak var codeVerificationInput: UITextField!
    weak var verificationCodeViewDelegate: VerificationCodeViewDelegate?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCodeInput()
    }
    
    // MARK: - Public methods
    func setInputFirstResponder() {
        codeVerificationInput.becomeFirstResponder()
    }
    
    func getCodeText() -> String {
        guard let text = codeVerificationInput.text else { return "" }
        return text
    }
    
    // MARK: - Private methods
    private func setupCodeInput() {
        codeVerificationInput.layer.borderWidth = 1
        codeVerificationInput.layer.borderColor = UIColor.clear.cgColor
        codeVerificationInput.layer.cornerRadius = 5
        codeVerificationInput.backgroundColor = .darkGray
        codeVerificationInput.becomeFirstResponder()
        codeVerificationInput.delegate = self
        codeVerificationInput.addTarget(self, 
                                        action: #selector(textFieldDidChange(_:)),
                                        for: .editingChanged)
    }
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, text.count == 1, text != "" {
            verificationCodeViewDelegate?.isLastEmpty(text: getCodeText())
            verificationCodeViewDelegate?.switchTextField(in: self)
        } else {
            verificationCodeViewDelegate?.deactivateConfirmButton()
        }
    }
}

// MARK: - VerificationCodeCell + UITextFieldDelegate
extension VerificationCodeCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false}
        let result = (text as NSString).replacingCharacters(in: range, with: string)
        return result.count <= 1
    }
}
