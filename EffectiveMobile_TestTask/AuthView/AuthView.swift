//
//  AuthView.swift
//  EffectiveMobile_TestTask
//
//  Created by Vyacheslav on 27.03.2024.
//

import UIKit

class AuthView: UIView {
    
    @IBOutlet private weak var emailInputField: EmailInput!
    @IBOutlet private weak var continueButton: UIButton!
    
    private var inputResult: String = ""
    private var clearActionHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    func makeContinueButtonDisabled() {
        continueButton.isUserInteractionEnabled = false
            continueButton.alpha = 0.5
    }
    
    func setActionHandler(_ actionHandler: (() -> Void)?) {
        clearActionHandler = actionHandler
    }
    
    private func loadViewFromXib() -> UIView {
        guard let view = Bundle.main.loadNibNamed("AuthView", owner: self)?.first as? UIView else {
            return UIView()
        }
        return view
    }
    
    private func configureView() {
        let subview = self.loadViewFromXib()
        subview.frame = self.bounds
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(subview)
        emailInputField.authViewDelegate = self
    }
    
    
    @IBAction func continueButtonAction(_ sender: Any) {
        inputResult = emailInputField.checkCorrectlyInput()
        if inputResult != "" {
            print("okay")
        } else {
            emailInputField.displayInputError()
        }
    }
}

extension AuthView: AuthViewDelegate {
    
    func buttonActivate() {
        continueButton.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.5) {
            self.continueButton.alpha = 1
        }
    }
    
    func buttonDeactivate() {
        continueButton.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.5) {
            self.continueButton.alpha = 0.5
        }
    }
}
