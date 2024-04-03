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
    var countOfFavouritesVacancies: Int = 0
    var favouriteModel: VacanciesModel? = nil
    
    struct ManagerModel {
        let lookingNumber: Int?
        let title: String
        let town: String
        let company: String
        let experience: String
        let publishedData: String
        let isFavourite: Bool
    }
    
    func getFavouritesData(model: VacanciesModel) {
        favouriteModel = model
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        authView.makeContinueButtonDisabled()
        checkRegistrationState()
        actionHandlers()
        authView.authDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(userRegistered), name: Notification.Name("UserRegisteredNotification"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vacanciesList.reloadData()
        vacanciesCountLabel.text = "\(countOfFavouritesVacancies) вакансий"
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
            vacanciesList.register(UINib(nibName: "VacanciesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "vacanciesCell")
            vacanciesList.dataSource = self
            vacanciesList.delegate = self
            vacanciesList.backgroundColor = .clear
        }
    }
}

extension FavouritesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countOfFavouritesVacancies
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = vacanciesList.dequeueReusableCell(withReuseIdentifier: "vacanciesCell", for: indexPath) as? VacanciesCollectionViewCell
               else {
            return UICollectionViewCell()
        }
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMMM"
        outputFormatter.locale = Locale(identifier: "ru_RU")
        
        if let model = favouriteModel {
            let date = inputFormatter.date(from: model.publishedDate)
            let formattedDate = outputFormatter.string(from: date ?? Date())

            cell.configure(cellModel:
                            VacanciesCollectionViewCell.VacancyCellModel(lookingNumber: model.lookingNumber,
                                                                         title: model.title,
                                                                         town: model.address.town,
                                                                         company: model.company,
                                                                         experience: model.experience.previewText,
                                                                         publishedDate: formattedDate,
                                                                        isFavourite: true))
        } else {
            return cell
        }

        return cell
    }
}

extension FavouritesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = favouriteModel else { return }
        let vacancyView = VacancyViewController(nibName: "VacancyViewController", bundle: nil)

        vacancyView.setModel(model: VacancyViewController.VacancyInfoModel(title: model.title,
                                                                           company: model.company,
                                                                           salary: model.salary.full,
                                                                           experience: model.experience.text,
                                                                           schedules: model.schedules,
                                                                           lookingNumber: model.lookingNumber,
                                                                           appliedNumber: model.appliedNumber,
                                                                           town: model.address.town,
                                                                           street: model.address.street,
                                                                           house: model.address.house,
                                                                           description: model.description,
                                                                           responsibilities: model.responsibilities,
                                                                           questions: model.questions))
        
        navigationController?.pushViewController(vacancyView, animated: true)
    }
}
