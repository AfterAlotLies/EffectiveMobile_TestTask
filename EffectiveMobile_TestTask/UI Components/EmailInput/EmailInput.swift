//
//  EmailInput.swift
//  EffectiveMobile_TestTask
//
//  Created by Vyacheslav on 27.03.2024.
//

import UIKit

class EmailInput: UIView {
    
    @IBOutlet private weak var emailInputField: UITextField!
    @IBOutlet private weak var clearFieldButton: UIButton!
    @IBOutlet private weak var errorMessage: UILabel!
    
    weak var authViewDelegate: AuthViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    func displayInputError() {
        UIView.animate(withDuration: 0.3) {
            self.errorMessage.alpha = 1.0
            self.emailInputField.layer.borderColor = UIColor.red.cgColor
        }
    }
    
    func checkCorrectlyInput() -> String{
        guard let inputText = emailInputField.text else { return "" }
        if (inputText.hasSuffix("@mail.ru") || inputText.hasSuffix("@gmail.com")) && inputText.hasPrefix("@") == false {
            return inputText
        } else {
            return ""
        }
    }
    
    private func loadViewFromXib() -> UIView {
        guard let view = Bundle.main.loadNibNamed("EmailInput", owner: self)?.first as? UIView else {
            return UIView()
        }
        return view
    }
    
    private func configureView() {
        let subview = self.loadViewFromXib()
        subview.frame = self.bounds
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(subview)
        setupEmailInputField()
    }
    
    private func setupEmailInputField() {
        emailInputField.attributedPlaceholder = NSAttributedString(string: "Электронная почта или телефон",
                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        clearFieldButton.isHidden = true
        emailInputField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        emailInputField.layer.borderWidth = 1
        emailInputField.layer.cornerRadius = 10
        emailInputField.layer.borderColor = UIColor.clear.cgColor
        errorMessage.alpha = 0
        setLeftViewImage()
    }
    
    private func setLeftViewImage() {
        emailInputField.leftViewMode = .always
        let image = UIImage(named: "emailImage")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        
        let imageWidth = 20.0
        let imageHeight = 20.0
        imageView.frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        
        let leftViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: imageWidth + 10, height: imageHeight))
        
        imageView.frame.origin.x = 10
        leftViewContainer.addSubview(imageView)
        
        emailInputField.leftView = leftViewContainer
    }
    
    @objc
    private func textFieldDidChanged(_ textField: UITextField) {
        if emailInputField.text == "" {
            clearFieldButton.isHidden = true
            authViewDelegate?.buttonDeactivate()
        } else {
            UIView.animate(withDuration: 0.3) {
                self.errorMessage.alpha = 0
                self.emailInputField.layer.borderColor = UIColor.clear.cgColor
            }
            clearFieldButton.isHidden = false
            emailInputField.leftViewMode = .unlessEditing
            authViewDelegate?.buttonActivate()
        }
    }

    @IBAction func clearInputField(_ sender: Any) {
        emailInputField.text = ""
        UIView.animate(withDuration: 0.3) {
            self.errorMessage.alpha = 0
            self.emailInputField.layer.borderColor = UIColor.clear.cgColor
        }
        clearFieldButton.isHidden = true
        authViewDelegate?.buttonDeactivate()
    }
}
