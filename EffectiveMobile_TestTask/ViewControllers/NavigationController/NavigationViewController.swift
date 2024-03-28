//
//  NavigationViewController.swift
//  EffectiveMobile_TestTask
//
//  Created by Vyacheslav on 27.03.2024.
//

import UIKit

// MARK: - NavigationViewController class
class NavigationViewController: UINavigationController {

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let menuController = MenuController()
        viewControllers = [menuController]
    }
}
