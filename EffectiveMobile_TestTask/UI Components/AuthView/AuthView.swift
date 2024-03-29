//
//  AuthView.swift
//  EffectiveMobile_TestTask
//
//  Created by Vyacheslav on 27.03.2024.
//

import UIKit

// MARK: - AuthView class
class AuthView: UIView {
    
    @IBOutlet private weak var emailInputField: EmailInput!
    @IBOutlet private weak var continueButton: UIButton!
    
    private var inputResult: String = ""
    private var continueActionHandler: (() -> Void)?
    
    weak var authDelegate: AuthViewDelegate?
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    private func loadViewFromXib() -> UIView {
        guard let view = Bundle.main.loadNibNamed("AuthView", owner: self)?.first as? UIView else {
            return UIView()
        }
        return view
    }
    
    // MARK: - Public methods
    func makeContinueButtonDisabled() {
        continueButton.isUserInteractionEnabled = false
        continueButton.alpha = 0.5
    }
    
    func setContinueActionHandler(_ actionHandler: (() -> Void)?) {
        continueActionHandler = actionHandler
    }
    
    // MARK: - IBAction
    @IBAction func continueButtonAction(_ sender: Any) {
        inputResult = emailInputField.checkCorrectlyInput()
        if inputResult == "" {
            emailInputField.displayInputError()
        } else {
            continueActionHandler?()
            authDelegate?.setUserEmail(emailAddress: inputResult)
        }
    }
    
    // MARK: - Private methods
    private func configureView() {
        let subview = self.loadViewFromXib()
        subview.frame = self.bounds
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(subview)
        emailInputField.authViewDelegate = self
    }
}

// MARK: - AuthView + AuthViewDelegate
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
