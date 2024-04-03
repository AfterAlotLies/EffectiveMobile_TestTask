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
    @IBOutlet private weak var moreVacanciesButton: UIButton!
    
    private let imagesArray: [String] = ["vacanciesRecommendImage", "starRecommendImage", "listRecommendImage", "vacanciesRecommendImage"]
    
    private let dataParser = DataParser.shared
    private let authManager = AuthManager.shared
    private var vacancyModel: Vacancies? = nil
    private var recommendModel: Offers? = nil
    var favouriteController: FavouritesViewController?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        authView.makeContinueButtonDisabled()
        actionHandlers()
        checkRegistrationState()
        authView.authDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(userRegistered), name: Notification.Name("UserRegisteredNotification"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    
    override func viewDidLayoutSubviews() {
        changeCollectionHeight()
    }
    
    // MARK: - Private methods
    private func setupNavBar()  {
        let barButton = UIBarButtonItem()
        barButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = barButton
    }
    
    private func setupMoreVacanciesButton() {
        moreVacanciesButton.layer.cornerRadius = 10
        moreVacanciesButton.backgroundColor = .systemBlue
        guard let model = vacancyModel else { return }
        switch model.vacancies.count {
            
        case 1:
            moreVacanciesButton.setTitle("Еще \(model.vacancies.count) вакансия", for: .normal)
            
        case 2, 3, 4:
            moreVacanciesButton.setTitle("Еще \(model.vacancies.count) вакансии", for: .normal)
            
        default:
            moreVacanciesButton.setTitle("Еще \(model.vacancies.count) вакансий", for: .normal)
            
        }
        moreVacanciesButton.setTitleColor(.white, for: .normal)
    }
    
    private func setupCollections() {
        let recommendCell = UINib(nibName: "RecommendationViewCell", bundle: nil)
        recommendCollection.register(recommendCell, forCellWithReuseIdentifier: "recommendCell")
        recommendCollection.dataSource = self
        recommendCollection.backgroundColor = .clear
        
        vacanciesCollectionView.register(UINib(nibName: "VacanciesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "vacanciesCell")
        vacanciesCollectionView.dataSource = self
        vacanciesCollectionView.delegate = self
        vacanciesCollectionView.backgroundColor = .clear
    }
    
    private func setRecommendData() {
        dataParser.getRecommendData { offers, error in
            if error != nil {
                print("Error: cannot set recommend data")
            } else if let offers = offers {
                self.recommendModel = offers
            }
        }
    }
    
    private func setVacanciesData() {
        dataParser.getVacancies { vacancies, error in
            if error != nil {
                print("Error: cannot set vacancies data")
            } else {
                if let vacancies = vacancies {
                    self.vacancyModel = vacancies
                }
            }
        }
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
        guard let model = recommendModel else { return 0 }
        if collectionView == vacanciesCollectionView {
            return 3
        } else if collectionView == recommendCollection {
            return model.offers.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == recommendCollection {
            guard let cell = recommendCollection.dequeueReusableCell(withReuseIdentifier: "recommendCell", for: indexPath) as? RecommendationViewCell,
                  let model = recommendModel?.offers[indexPath.row] else {
                return UICollectionViewCell()
            }
            
            cell.setImage(imageName: imagesArray[indexPath.row])
            cell.configure(cellModel: RecommendationViewCell.RecommendationCellModel(title: model.title))
            
            if indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 3 {
                cell.hideButton()
            } else {
                cell.setRecommendUpButton(text: "Поднять")
            }
            return cell

        } else if collectionView == vacanciesCollectionView {
            guard let cell = vacanciesCollectionView.dequeueReusableCell(withReuseIdentifier: "vacanciesCell", for: indexPath) as? VacanciesCollectionViewCell,
                  let model = vacancyModel?.vacancies[indexPath.row] else {
                return UICollectionViewCell()
            }
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd"
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "d MMMM"
            outputFormatter.locale = Locale(identifier: "ru_RU")
            let date = inputFormatter.date(from: model.publishedDate)
            let formattedDate = outputFormatter.string(from: date ?? Date())
            cell.configure(cellModel:
                            VacanciesCollectionViewCell.VacancyCellModel(lookingNumber: model.lookingNumber,
                                                                         title: model.title,
                                                                         town: model.address.town,
                                                                         company: model.company,
                                                                         experience: model.experience.previewText,
                                                                         publishedDate: formattedDate,
                                                                        isFavourite: false))
            cell.addToFavoutireHandler = { [weak self] in
                guard let self = self else { return }
                self.favouriteController?.getFavouritesData(model: model)
                self.favouriteController?.countOfFavouritesVacancies += 1
            }
            return cell
        }
        
        return UICollectionViewCell()
    }
}

//MARK: - SearchViewController + UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = vacancyModel?.vacancies[indexPath.row] else { return }
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
            setupCollections()
            setRecommendData()
            setVacanciesData()
            setupMoreVacanciesButton()
        }
    }
}
