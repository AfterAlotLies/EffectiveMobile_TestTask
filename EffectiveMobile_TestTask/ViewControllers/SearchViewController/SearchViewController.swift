//
//  SearchViewController.swift
//  EffectiveMobile_TestTask
//
//  Created by Vyacheslav on 27.03.2024.
//

import UIKit

// MARK: - SearchViewController class
class SearchViewController: UIViewController {
    
    @IBOutlet private weak var verificationCodeView: VerificationCodeView!
    @IBOutlet private weak var authView: AuthView!
    
    private let authManager = AuthManager.shared
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        authView.makeContinueButtonDisabled()
        actionHandlers()
        setupVerificationView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isLoggedIn()
    }
    
    private func actionHandlers() {
        authView.setActionHandler {
            self.authView.isHidden = true
            UIView.animate(withDuration: 0.3) {
                self.verificationCodeView.isHidden = false
                self.verificationCodeView.alpha = 1
                self.tabBarController?.tabBar.isUserInteractionEnabled = false
            }
        }
        
        verificationCodeView.setConfirmActionHandler {
            self.verificationCodeView.isHidden = true
            self.showViewByStatus(status: .show)
            self.authManager.login()
            self.tabBarController?.tabBar.isUserInteractionEnabled = true
        }
    }
    
    private func setupVerificationView() {
        verificationCodeView.alpha = 0
        verificationCodeView.isHidden = true
    }
    
    private func isLoggedIn() {
        if let isLoggedIn = authManager.isLoggedIn {
            if isLoggedIn {
                authView.isHidden = true
                showViewByStatus(status: .show)
            }
        }
    }
    
    private func showViewByStatus(status: ViewVisibilityStatus) {
        switch status {
        case .hide:
            print("smth")

        case .show:
            print("smth")
        }
    }
}
