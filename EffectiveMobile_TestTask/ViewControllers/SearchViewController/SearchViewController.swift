//
//  SearchViewController.swift
//  EffectiveMobile_TestTask
//
//  Created by Vyacheslav on 27.03.2024.
//

import UIKit

// MARK: - SearchViewController class
class SearchViewController: UIViewController {
    
    @IBOutlet private weak var scrollContent: UIScrollView!
    @IBOutlet private weak var vacanciesCollectionView: UICollectionView!
    @IBOutlet private weak var verificationView: VerificationCodeView!
    @IBOutlet private weak var authView: AuthView!
    @IBOutlet private weak var searchView: SearchView!
    @IBOutlet private weak var recommendCollection: UICollectionView!
    @IBOutlet private weak var vacanciesCollectionViewHeight: NSLayoutConstraint!
    
    private let authManager = AuthManager.shared
    private let imagesArray: [String] = ["vacanciesRecommendImage", "starRecommendImage", "listRecommendImage", "vacanciesRecommendImage"]
    private var recommendDataArray = [String]()
    private var vacanciesDataArray = [String]()
    private let dataParser = DataParser.shared
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        authView.makeContinueButtonDisabled()
        actionHandlers()
        checkRegistrationState()
        authView.authDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(userRegistered), name: Notification.Name("UserRegisteredNotification"), object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        changeCollectionHeight()
    }
    
    // MARK: - Private methods
    private func setupCollections() {
        let recommendCell = UINib(nibName: "RecommendationViewCell", bundle: nil)
        recommendCollection.register(recommendCell, forCellWithReuseIdentifier: "recommendCell")
        recommendCollection.dataSource = self
        recommendCollection.backgroundColor = .clear
        
        vacanciesCollectionView.register(UINib(nibName: "VacanciesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "vacanciesCell")
        vacanciesCollectionView.dataSource = self
        vacanciesCollectionView.backgroundColor = .clear
    }
    
    private func setRecommendData() {
        dataParser.getRecommendData { offers, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if let offers = offers {
                for offer in offers.offers {
                    self.recommendDataArray.append(offer.title)
                }
            }
        }
    }
    
    private func setVacanciesData() {
        dataParser.getVacancies { vacancies, error in
            if error != nil {
                print("error")
            } else {
                if let vacancies = vacancies {
                    for vacancy in vacancies.vacancies {
                        self.addDataToArray(vacancy: vacancy)
                    }
                }
            }
        }
    }
    
    private func addDataToArray(vacancy: VacanciesModel) {
        if let lookingNumber = vacancy.lookingNumber {
            vacanciesDataArray.append(String(lookingNumber))
        } else {
            vacanciesDataArray.append("")
        }
        vacanciesDataArray.append(vacancy.title)
        vacanciesDataArray.append(vacancy.address.town)
        vacanciesDataArray.append(vacancy.company)
        vacanciesDataArray.append(vacancy.experience.previewText)
        vacanciesDataArray.append(vacancy.publishedDate)
    }
    
    //Check is user logged in
    @objc
    private func userRegistered() {
        checkRegistrationState()
    }
}

// MARK: - SearchViewController + UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    
    func changeCollectionHeight() {
        vacanciesCollectionViewHeight.constant = vacanciesCollectionView.contentSize.height
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == vacanciesCollectionView {
            return 3
        } else if collectionView == recommendCollection {
            return recommendDataArray.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == recommendCollection {
            guard let cell = recommendCollection.dequeueReusableCell(withReuseIdentifier: "recommendCell", for: indexPath) as? RecommendationViewCell else {
                return UICollectionViewCell()
            }
            
            cell.setImage(imageName: imagesArray[indexPath.row])
            cell.setRecommendText(text: recommendDataArray[indexPath.row])
            
            if indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 3 {
                cell.hideButton()
            } else {
                cell.setRecommendUpButton(text: "Поднять")
            }
            return cell

        } else if collectionView == vacanciesCollectionView {
            guard let cell = vacanciesCollectionView.dequeueReusableCell(withReuseIdentifier: "vacanciesCell", for: indexPath) as? VacanciesCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let startIndex = indexPath.item * 6
            
            guard startIndex + 5 < vacanciesDataArray.count else {
                return cell
            }
            
            cell.fillLookinNumberLabel(lookingNumber: vacanciesDataArray[startIndex])
            cell.fillVacancyNameLabel(vacancyName: vacanciesDataArray[startIndex + 1])
            cell.fillTownLabel(townName: vacanciesDataArray[startIndex + 2])
            cell.fillCompanyLabel(companyName: vacanciesDataArray[startIndex + 3])
            cell.fillExperienceLabel(experience: vacanciesDataArray[startIndex + 4])
            
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd"
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "d MMMM"
            outputFormatter.locale = Locale(identifier: "ru_RU")
            let dateString = vacanciesDataArray[startIndex + 5]
            
            if let date = inputFormatter.date(from: dateString) {
                let formattedDate = outputFormatter.string(from: date)
                cell.fillPublishedDateLabel(publishedDate: formattedDate)
            } else {
                cell.fillPublishedDateLabel(publishedDate: "")
            }
            return cell
        }

        return UICollectionViewCell()
    }
}

// MARK: - SearchViewController + AuthViewDelegate
extension SearchViewController: AuthViewDelegate {
    
    func setUserEmail(emailAddress: String) {
        verificationView.setEmailToLabel(emailAddress: emailAddress)
    }
}

// MARK: - SearchViewController + ViewVisibilityDelegate
extension SearchViewController: ViewVisibilityDelegate {
    
    func checkRegistrationState() {
        if let isLoggedIn = authManager.isLoggedIn {
            if isLoggedIn {
                showViewByStatus(status: .show)
                setupCollections()
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
            self.view.endEditing(true)
            self.showViewByStatus(status: .show)
            self.authManager.login()
            self.tabBarController?.tabBar.isUserInteractionEnabled = true
        }
    }
    
    func showViewByStatus(status: ViewVisibilityStatus) {
        switch status {
        case .hide:
            scrollContent.isHidden = true
            verificationView.alpha = 0
            verificationView.isHidden = true

        case .show:
            authView.isHidden = true
            verificationView.isHidden = true
            scrollContent.isHidden = false
            setRecommendData()
            setVacanciesData()
        }
    }
}
