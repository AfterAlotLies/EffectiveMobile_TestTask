//
//  FavouritesViewController.swift
//  EffectiveMobile_TestTask
//
//  Created by Vyacheslav on 27.03.2024.
//

import UIKit

// MARK: - FavouritesViewController class
class FavouritesViewController: UIViewController {

    @IBOutlet private weak var authView: AuthView!
    @IBOutlet private weak var favouritesLabel: UILabel!
    @IBOutlet private weak var vacanciesCountLabel: UILabel!
    @IBOutlet private weak var vacanciesList: UICollectionView!
    @IBOutlet private weak var verificationView: VerificationCodeView!
    
    private let authManager = AuthManager.shared
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        authView.makeContinueButtonDisabled()
        setupVerificationView()
        showViewByStatus(status: .hide)
        actionHandlers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isLoggedIn()
    }
    
    // MARK: - Private methods
    private func actionHandlers() {
        authView.setActionHandler {
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
    
    private func setupVerificationView() {
        verificationView.alpha = 0
        verificationView.isHidden = true
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
            favouritesLabel.isHidden = true
            vacanciesList.isHidden = true
            vacanciesCountLabel.isHidden = true

        case .show:
            favouritesLabel.isHidden = false
            vacanciesList.isHidden = false
            vacanciesCountLabel.isHidden = false
        }
    }
}