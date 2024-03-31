//
//  ItemCollectionViewCell.swift
//  EffectiveMobile_TestTask
//
//  Created by Vyacheslav on 30.03.2024.
//

import UIKit

class VacanciesCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var lookingNumberLabel: UILabel!
    @IBOutlet private weak var addToFavourites: UIButton!
    @IBOutlet private weak var vacancyNameLabel: UILabel!
    @IBOutlet private weak var townLabel: UILabel!
    @IBOutlet private weak var companyLabel: UILabel!
    @IBOutlet private weak var experienceLabel: UILabel!
    @IBOutlet private weak var publishedDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
    }
    
    func fillLookinNumberLabel(lookingNumber: String) {
        switch lookingNumber {
        case "2", "3", "4":
            lookingNumberLabel.text = "Сейчас просматривает \(lookingNumber) человека"
        case "":
            lookingNumberLabel.isHidden = true
        default:
            lookingNumberLabel.text = "Сейчас просматривает \(lookingNumber) человек"
        }
    }
    
    func fillVacancyNameLabel(vacancyName: String) {
        vacancyNameLabel.text = vacancyName
    }
    
    func fillTownLabel(townName: String) {
        townLabel.text = townName
    }
    
    func fillCompanyLabel(companyName: String) {
        companyLabel.text = companyName
    }
    
    func fillExperienceLabel(experience: String) {
        experienceLabel.text = experience
    }
    
    func fillPublishedDateLabel(publishedDate: String) {
        if publishedDate != "" {
            publishedDateLabel.text = "Опубликовано \(publishedDate)"
        } else {
            publishedDateLabel.text = publishedDate
        }
    }
    
    private func setupView() {
        addToFavourites.layer.borderWidth = 1
        addToFavourites.layer.borderColor = UIColor.clear.cgColor
        addToFavourites.layer.cornerRadius = 10
    }

}
