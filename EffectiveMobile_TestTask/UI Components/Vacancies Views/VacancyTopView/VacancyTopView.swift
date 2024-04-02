//
//  VacancyTopView.swift
//  EffectiveMobile_TestTask
//
//  Created by Vyacheslav on 02.04.2024.
//

import UIKit

// MARK: - VacancyTopView
class VacancyTopView: UIView {
    
    @IBOutlet private weak var appliedNumberLabel: UILabel!
    @IBOutlet private weak var lookingNumberLabel: UILabel!
    @IBOutlet private weak var rightView: UIView!
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    private func loadViewFromXib() -> UIView {
        guard let view = Bundle.main.loadNibNamed("VacancyTopView", owner: self)?.first as? UIView else {
            return UIView()
        }
        return view
    }

    // MARK: - Public methods
    func setAppliedNumber(appliedNumber: Int) {
        appliedNumberLabel.text = "\(appliedNumber) человек уже откликнулись"
    }
    
    func setLookingNumber(lookingNumber: Int?) {
        guard let lookingNumber = lookingNumber else {
            rightView.isHidden = true
            return
        }
        
        let remainderTen = lookingNumber % 10
        let remainderHundred = lookingNumber % 100
        
        switch remainderTen {
        case 1:
            if remainderHundred != 11 {
                lookingNumberLabel.text = "\(lookingNumber) человек сейчас смотрят"
            }
        case 2, 3, 4:
            if remainderHundred != 12 && remainderHundred != 13 && remainderHundred != 14 {
                lookingNumberLabel.text = "\(lookingNumber) человека сейчас смотрят"
            }
        default:
            break
        }
    }

    // MARK: - Private methods
    private func configureView() {
        let subview = self.loadViewFromXib()
        subview.frame = self.bounds
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(subview)
    }
}
