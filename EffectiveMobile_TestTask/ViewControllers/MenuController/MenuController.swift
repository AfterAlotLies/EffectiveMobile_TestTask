//
//  MenuController.swift
//  EffectiveMobile_TestTask
//
//  Created by Vyacheslav on 27.03.2024.
//

import UIKit

// MARK: - MenuController class
class MenuController: UITabBarController {
    
    private let authManager = AuthManager.shared
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuBar()
        setupTopBorder()
    }
    
    // MARK: - Setup Methods
    private func setupMenuBar() {
        let searchController = SearchViewController()
        let favouritesController = FavouritesViewController()
        let responsesController = ResponsesViewController()
        let messagesController = MessagesViewController()
        let profileController = ProfileViewController()
        
        searchController.title = "Поиск"
        favouritesController.title = "Избранное"
        responsesController.title = "Отклики"
        messagesController.title = "Сообщения"
        profileController.title = "Профиль"
        
        setViewControllers([searchController, favouritesController, responsesController, messagesController, profileController], animated: false)
        
        guard let items = self.tabBar.items else { return }
        
        let images = ["searchImage", "favouritesImage", "responsesImage", "messagesProfile", "profileImage"]
        
        for item in 0...4 {
            items[item].image = UIImage(named: images[item])
        }
        
        if let isLoggedIn = authManager.isLoggedIn {
            if isLoggedIn {
                selectedIndex = 0
            } else {
                selectedIndex = 1
            }
        }
    }
    
    private func setupTopBorder() {
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: 0.5)
        topBorder.backgroundColor = UIColor.darkGray.cgColor
        tabBar.layer.addSublayer(topBorder)
        tabBar.unselectedItemTintColor = .gray
    }
}
