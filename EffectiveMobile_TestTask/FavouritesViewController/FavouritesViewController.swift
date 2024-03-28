//
//  FavouritesViewController.swift
//  EffectiveMobile_TestTask
//
//  Created by Vyacheslav on 27.03.2024.
//

import UIKit

class FavouritesViewController: UIViewController {

    @IBOutlet private weak var authView: AuthView!
    @IBOutlet private weak var favouritesLabel: UILabel!
    @IBOutlet private weak var vacanciesCountLabel: UILabel!
    @IBOutlet private weak var vacanciesList: UICollectionView!
    @IBOutlet private weak var verificationView: VerificationCodeView!
    
    private let authManager = AuthManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authView.makeContinueButtonDisabled()
        hideFavouritesView()
        verificationView.alpha = 0
        verificationView.isHidden = true
        actionHandlers()
        isLoggedIn()
    }
    
    private func actionHandlers() {
        authView.setActionHandler {
            self.authView.isHidden = true
            UIView.animate(withDuration: 0.3) {
                self.verificationView.isHidden = false
                self.verificationView.alpha = 1
            }
        }
        
        verificationView.setConfirmActionHandler {
            self.verificationView.isHidden = true
            self.showFavouritesView()
            self.authManager.login()
        }
    }
    
    private func isLoggedIn() {
        if let isLoggedIn = authManager.isLoggedIn {
            if isLoggedIn {
                authView.isHidden = true
                showFavouritesView()
            }
        }
    }
    
    private func hideFavouritesView() {
        favouritesLabel.isHidden = true
        vacanciesList.isHidden = true
        vacanciesCountLabel.isHidden = true
    }
    
    private func showFavouritesView() {
        favouritesLabel.isHidden = false
        vacanciesList.isHidden = false
        vacanciesCountLabel.isHidden = false
    }
}


