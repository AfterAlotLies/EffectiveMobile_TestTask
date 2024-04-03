//
//  ItemCollectionViewCell.swift
//  EffectiveMobile_TestTask
//
//  Created by Vyacheslav on 30.03.2024.
//

import UIKit

// MARK: - VacanciesCollectionViewCell
class VacanciesCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var lookingNumberLabel: UILabel!
    @IBOutlet private weak var addToFavourites: UIButton!
    @IBOutlet private weak var vacancyNameLabel: UILabel!
    @IBOutlet private weak var townLabel: UILabel!
    @IBOutlet private weak var companyLabel: UILabel!
    @IBOutlet private weak var experienceLabel: UILabel!
    @IBOutlet private weak var publishedDateLabel: UILabel!
    @IBOutlet private weak var shareButton: UIButton!
    
    private var isFavourite: Bool = false
    
    var addToFavoutireHandler: (() -> Void)?
    
    // MARK: - VacancyCellModel
    struct VacancyCellModel {
        let lookingNumber: Int?
        let title: String
        let town: String
        let company: String
        let experience: String
        let publishedDate: String
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    // MARK: - Public methods
    func configure(cellModel: VacancyCellModel) {
        fillLookinNumberLabel(lookingNumber: cellModel.lookingNumber)
        fillVacancyNameLabel(vacancyName: cellModel.title)
        fillTownLabel(townName: cellModel.town)
        fillCompanyLabel(companyName: cellModel.company)
        fillExperienceLabel(experience: cellModel.experience)
        fillPublishedDateLabel(publishedDate: cellModel.publishedDate)
    }

    // MARK: - IBAaction
    @IBAction func addVacancyToFavourites(_ sender: Any) {
        if !isFavourite {
            addToFavourites.setImage(UIImage(named: "favouriteActiveImage"), for: .normal)
            isFavourite = true
            addToFavoutireHandler?()
        } else {
            addToFavourites.setImage(UIImage(named: "favouritesImage"), for: .normal)
            isFavourite = false
        }
    }

    // MARK: - Private methods
    private func fillLookinNumberLabel(lookingNumber: Int?) {
        guard let number = lookingNumber else {
            lookingNumberLabel.isHidden = true
            return
        }
        switch number {
        case 2, 3, 4:
            lookingNumberLabel.text = "Сейчас просматривает \(number) человека"
        default:
            lookingNumberLabel.text = "Сейчас просматривает \(number) человек"
        }
    }
    
    private func fillVacancyNameLabel(vacancyName: String) {
        vacancyNameLabel.text = vacancyName
    }
    
    private func fillTownLabel(townName: String) {
        townLabel.text = townName
    }
    
    private func fillCompanyLabel(companyName: String) {
        companyLabel.text = companyName
    }
    
    private func fillExperienceLabel(experience: String) {
        experienceLabel.text = experience
    }
    
    private func fillPublishedDateLabel(publishedDate: String) {
        if publishedDate != "" {
            publishedDateLabel.text = "Опубликовано \(publishedDate)"
        } else {
            publishedDateLabel.text = publishedDate
        }
    }
    
    private func setupView() {
        shareButton.layer.borderWidth = 1
        shareButton.layer.borderColor = UIColor.clear.cgColor
        shareButton.layer.cornerRadius = 15
    }

}
