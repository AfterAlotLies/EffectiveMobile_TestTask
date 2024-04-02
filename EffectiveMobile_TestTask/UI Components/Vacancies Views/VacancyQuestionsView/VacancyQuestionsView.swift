//
//  VacancyQuestionsView.swift
//  EffectiveMobile_TestTask
//
//  Created by Vyacheslav on 02.04.2024.
//

import UIKit

// MARK: - VacancyQuestionsView
class VacancyQuestionsView: UIView {
    
    @IBOutlet private weak var firstQuestion: UIButton!
    @IBOutlet private weak var secondQuestion: UIButton!
    @IBOutlet private weak var thirdQuestion: UIButton!
    @IBOutlet private weak var fourthQuestion: UIButton!
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }

    // MARK: - Public methods
    func setupQuestions(questions: [String]) {
        if questions.count >= 1 {
            firstQuestion.setTitle(questions[0], for: .normal)
        }
        if questions.count >= 2 {
            secondQuestion.setTitle(questions[1], for: .normal)
        } else {
            secondQuestion.isHidden = true
            thirdQuestion.isHidden = true
            fourthQuestion.isHidden = true
        }
        if questions.count >= 3 {
            thirdQuestion.setTitle(questions[2], for: .normal)
        } else {
            thirdQuestion.isHidden = true
            fourthQuestion.isHidden = true
        }
        if questions.count >= 4 {
            fourthQuestion.setTitle(questions[3], for: .normal)
        } else {
            fourthQuestion.isHidden = true
        }
    }

    // MARK: - Private methods
    private func loadViewFromXib() -> UIView {
        guard let view = Bundle.main.loadNibNamed("VacancyQuestionsView", owner: self)?.first as? UIView else {
            return UIView()
        }
        return view
    }
    
    private func configureView() {
        let subview = self.loadViewFromXib()
        subview.frame = self.bounds
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(subview)
        setupLabels()
    }
    
    private func setupLabels() {
        firstQuestion.layer.borderWidth = 1
        firstQuestion.layer.borderColor = UIColor.clear.cgColor
        firstQuestion.layer.cornerRadius = 15
        firstQuestion.setTitleColor(.white, for: .normal)
        
        secondQuestion.layer.borderWidth = 1
        secondQuestion.layer.borderColor = UIColor.clear.cgColor
        secondQuestion.layer.cornerRadius = 15
        secondQuestion.setTitleColor(.white, for: .normal)
        
        thirdQuestion.layer.borderWidth = 1
        thirdQuestion.layer.borderColor = UIColor.clear.cgColor
        thirdQuestion.layer.cornerRadius = 15
        thirdQuestion.setTitleColor(.white, for: .normal)
        
        fourthQuestion.layer.borderWidth = 1
        fourthQuestion.layer.borderColor = UIColor.clear.cgColor
        fourthQuestion.layer.cornerRadius = 15
        fourthQuestion.setTitleColor(.white, for: .normal)
    }
}
