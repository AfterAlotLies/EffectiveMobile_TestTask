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
        authView.authDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isLoggedIn()
    }
}

// MARK: - FavouritesViewController + AuthViewDelegate
extension FavouritesViewController: AuthViewDelegate {
    
    func setUserEmail(emailAddress: String) {
        verificationView.setEmailToLabel(emailAddress: emailAddress)
    }
}

// MARK: - FavouritesViewController + ViewVisibilityDelegate
extension FavouritesViewController: ViewVisibilityDelegate {
    
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
