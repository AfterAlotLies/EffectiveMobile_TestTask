//
//  VacancyViewController.swift
//  EffectiveMobile_TestTask
//
//  Created by Vyacheslav on 01.04.2024.
//

import UIKit

// MARK: - VacancyViewController
class VacancyViewController: UIViewController {
    
    @IBOutlet private weak var vacancyTitleLabel: UILabel!
    @IBOutlet private weak var vacancySalaryLabel: UILabel!
    @IBOutlet private weak var vacancyExperienceLabel: UILabel!
    @IBOutlet private weak var vacancyScheduleLabel: UILabel!
    @IBOutlet private weak var vacancyTopView: VacancyTopView!
    @IBOutlet private weak var mapView: VacancyMapView!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var responsibilitiesTextView: UITextView!
    @IBOutlet private weak var tasksLabel: UILabel!
    @IBOutlet private weak var vacancyQuestionsView: VacancyQuestionsView!
    
    private let dataParser = DataParser.shared
    private var vacancyModel: VacancyInfoModel?

    // MARK: - VacancyInfoModel
    struct VacancyInfoModel {
        let title: String
        let company: String
        let salary: String
        let experience: String
        let schedules: [String]
        let lookingNumber: Int?
        let appliedNumber: Int?
        let town: String
        let street: String
        let house: String
        let description: String?
        let responsibilities: String
        let questions: [String]
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTopItemsNavBar()
        if let vacancyModel = vacancyModel {
            configure(viewModel: vacancyModel)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if vacancyTopView.isHidden {
            mapView.topAnchor.constraint(equalTo: vacancyScheduleLabel.bottomAnchor, constant: 16).isActive = true
        } else if descriptionTextView.isHidden {
            tasksLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 8).isActive = true
        }
    }
    
    // MARK: - Public methods
    func setModel(model: VacancyInfoModel) {
        vacancyModel = model
    }
    
    // MARK: - Private methods
    private func configure(viewModel: VacancyInfoModel) {
        setTitle(titleText: viewModel.title)
        setSalary(salary: viewModel.salary)
        setExperience(experience: viewModel.experience)
        setSchedules(schedules: viewModel.schedules)
        if let appliedNumber = viewModel.appliedNumber {
            vacancyTopView.setAppliedNumber(appliedNumber: appliedNumber)
        } else {
            vacancyTopView.isHidden = true
            view.layoutIfNeeded()
        }
        vacancyTopView.setLookingNumber(lookingNumber: viewModel.lookingNumber)
        mapView.setCompanyNameLabel(name: viewModel.company)
        mapView.setAddressLabel(town: viewModel.town, street: viewModel.street, house: viewModel.house)
        mapView.showLocationOnMap(address: "\(viewModel.town) \(viewModel.street.replacingOccurrences(of: "улица", with: "")) \(viewModel.house)")
        if let description = viewModel.description {
            descriptionTextView.text = description
            descriptionTextView.adjustUITextViewHeight()
        } else {
            descriptionTextView.isHidden = true
            view.layoutIfNeeded()
        }
        responsibilitiesTextView.text = viewModel.responsibilities
        responsibilitiesTextView.adjustUITextViewHeight()
        vacancyQuestionsView.setupQuestions(questions: viewModel.questions)
    }
    
    private func setTitle(titleText: String) {
        vacancyTitleLabel.text = titleText
    }
    
    private func setSalary(salary: String) {
        vacancySalaryLabel.text = salary
    }
    
    private func setExperience(experience: String) {
        vacancyExperienceLabel.text = "Требуемый опыт: \(experience)"
    }
    
    private func setSchedules(schedules: [String]) {
        vacancyScheduleLabel.text = schedules.prefix(1).map { $0.capitalized }.joined() + ", " + schedules.dropFirst().joined(separator: ", ")
    }
    
    private func setupTopItemsNavBar() {
        let barButton = UIButton()
        let eyeButton = UIButton(frame: CGRect(x: -100, y: 0, width: 30, height: 30))
        let moreButton = UIButton(frame: CGRect(x: -50, y: 0, width: 30, height: 30))
        let isFavouriteButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        
        eyeButton.setImage(UIImage(named: "eyeImage"), for: .normal)
        moreButton.setImage(UIImage(named: "moreImage"), for: .normal)
        isFavouriteButton.setImage(UIImage(named: "favouritesImage"), for: .normal)
        
        eyeButton.imageView?.contentMode = .scaleAspectFit
        moreButton.imageView?.contentMode = .scaleAspectFit
        isFavouriteButton.imageView?.contentMode = .scaleAspectFit
        
        barButton.addSubview(eyeButton)
        barButton.addSubview(moreButton)
        barButton.addSubview(isFavouriteButton)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barButton)
        
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        standardAppearance.configureWithOpaqueBackground()
        standardAppearance.backgroundColor = UIColor.clear
        
        navigationController?.navigationBar.standardAppearance = standardAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = standardAppearance
        
        if let backImage = UIImage(named: "backButtonImage")?.withRenderingMode(.alwaysOriginal) {
            navigationController?.navigationBar.backIndicatorImage = backImage
            navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        }
    }
}
