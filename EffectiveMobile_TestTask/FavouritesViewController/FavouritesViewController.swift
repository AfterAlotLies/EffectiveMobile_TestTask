//
//  FavouritesViewController.swift
//  EffectiveMobile_TestTask
//
//  Created by Vyacheslav on 27.03.2024.
//

import UIKit

class FavouritesViewController: UIViewController {

    @IBOutlet weak var authView: AuthView!
    @IBOutlet weak var testView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authView.makeContinueButtonDisabled()
        testView.isHidden = true
    }
}


