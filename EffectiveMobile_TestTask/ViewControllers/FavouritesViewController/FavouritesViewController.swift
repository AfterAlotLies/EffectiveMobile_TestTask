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
    private var vacancyModel: Vacancies? = nil
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        authView.makeContinueButtonDisabled()
        checkRegistrationState()
        actionHandlers()
        authView.authDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(userRegistered), name: Notification.Name("UserRegisteredNotification"), object: nil)
    }

    //Check user auth
    @objc
    private func userRegistered() {
        checkRegistrationState()
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
        authView.setContinueActionHandler { [weak self] in
            guard let self = self else { return }
            self.authView.isHidden = true
            UIView.animate(withDuration: 0.3) {
                self.verificationView.isHidden = false
                self.verificationView.alpha = 1
                self.tabBarController?.tabBar.isUserInteractionEnabled = false
            }
        }
        
        verificationView.setConfirmActionHandler { [weak self] in
            guard let self = self else { return }
            self.showViewByStatus(status: .show)
            self.authManager.login()
            self.tabBarController?.tabBar.isUserInteractionEnabled = true
        }
    }
    
    func showViewByStatus(status: ViewVisibilityStatus) {
        switch status {
        case .hide:
            favouritesLabel.isHidden = true
            vacanciesList.isHidden = true
            vacanciesCountLabel.isHidden = true
            verificationView.alpha = 0
            verificationView.isHidden = true
            
        case .show:
            favouritesLabel.isHidden = false
            vacanciesList.isHidden = false
            vacanciesCountLabel.isHidden = false
            authView.isHidden = true
            verificationView.isHidden = true
            vacanciesList.backgroundColor = .clear
        }
    }
}
