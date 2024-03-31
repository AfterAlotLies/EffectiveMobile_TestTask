//
//  MessagesViewController.swift
//  EffectiveMobile_TestTask
//
//  Created by Vyacheslav on 27.03.2024.
//

import UIKit

class MessagesViewController: UIViewController {

    @IBOutlet private weak var authView: AuthView!
    @IBOutlet private weak var verificationView: VerificationCodeView!
    
    private let authManager = AuthManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authView.makeContinueButtonDisabled()
        actionHandlers()
        checkRegistrationState()
        authView.authDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(userRegistered), name: Notification.Name("UserRegisteredNotification"), object: nil)
    }
    
    @objc func userRegistered() {
        checkRegistrationState()
    }
}

// MARK: - MessagesViewController + AuthViewDelegate
extension MessagesViewController: AuthViewDelegate {
    
    func setUserEmail(emailAddress: String) {
        verificationView.setEmailToLabel(emailAddress: emailAddress)
    }
}

// MARK: - MessagesViewController + ViewVisibilityDelegate
extension MessagesViewController: ViewVisibilityDelegate {
    
    func checkRegistrationState() {
        if let isLoggedIn = authManager.isLoggedIn {
            if isLoggedIn {
                showViewByStatus(status: .show)
            } else {
                showViewByStatus(status: .hide)
            }
        }
    }
    
    func actionHandlers() {
        authView.setContinueActionHandler {
            self.authView.isHidden = true
            UIView.animate(withDuration: 0.3) {
                self.verificationView.isHidden = false
                self.verificationView.alpha = 1
                self.tabBarController?.tabBar.isUserInteractionEnabled = false
            }
        }
        
        verificationView.setConfirmActionHandler {
            self.verificationView.isHidden = true
            self.showViewByStatus(status: .show)
            self.authManager.login()
            self.tabBarController?.tabBar.isUserInteractionEnabled = true
        }
    }
    
    func isLoggedIn() {
        if let isLoggedIn = authManager.isLoggedIn {
            if isLoggedIn {
                authView.isHidden = true
                showViewByStatus(status: .show)
            }
        }
    }
    
    func showViewByStatus(status: ViewVisibilityStatus) {
        switch status {
        case .hide:
            print("")
            verificationView.alpha = 0
            verificationView.isHidden = true
            
        case .show:
            authView.isHidden = true
            verificationView.isHidden = true
        }
    }
}
