//
//  ResponsesViewController.swift
//  EffectiveMobile_TestTask
//
//  Created by Vyacheslav on 27.03.2024.
//

import UIKit

class ResponsesViewController: UIViewController {
    
    @IBOutlet private weak var verificationView: VerificationCodeView!
    @IBOutlet private weak var authView: AuthView!
    
    private let authManager = AuthManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authView.makeContinueButtonDisabled()
        actionHandlers()
        setupVerificationView()
        authView.authDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isLoggedIn()
    }
}

// MARK: - ResponsesViewController + AuthViewDelegate
extension ResponsesViewController: AuthViewDelegate {
    
    func setUserEmail(emailAddress: String) {
        verificationView.setEmailToLabel(emailAddress: emailAddress)
    }
}

// MARK: - ResponsesViewController + ViewVisibilityDelegate
extension ResponsesViewController: ViewVisibilityDelegate {
    
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
    
    func setupVerificationView() {
        verificationView.alpha = 0
        verificationView.isHidden = true
    }
    
    func showViewByStatus(status: ViewVisibilityStatus) {
        switch status {
        case .hide:
            print("")
            
        case .show:
            print("")
        }
    }
}
