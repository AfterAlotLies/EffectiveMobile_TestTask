//
//  SearchView.swift
//  EffectiveMobile_TestTask
//
//  Created by Vyacheslav on 29.03.2024.
//

import UIKit

class SearchView: UIView {
    
    @IBOutlet private weak var searchField: UITextField!
    @IBOutlet private weak var filterButton: UIButton!
    
    private let darkGreyColor: UIColor = UIColor(red: 34.0 / 255.0, green: 35.0 / 255.0, blue: 37.0 / 255.0, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    private func loadViewFromXib() -> UIView {
        guard let view = Bundle.main.loadNibNamed("SearchView", owner: self)?.first as? UIView else {
            return UIView()
        }
        return view
    }
    
    private func configureView() {
        let subview = self.loadViewFromXib()
        subview.frame = self.bounds
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(subview)
        setupSearchField()
        setupFilterButton()
    }
    
    private func setupSearchField() {
        searchField.layer.borderWidth = 1
        searchField.layer.borderColor = UIColor.clear.cgColor
        searchField.layer.cornerRadius = 15
        searchField.backgroundColor = darkGreyColor
        searchField.attributedPlaceholder = NSAttributedString(string: "Должность, ключевые слова", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        setLeftViewSearchField()
    }
    
    private func setLeftViewSearchField() {
        searchField.leftViewMode = .always
        let image = UIImage(named: "searchImage")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        
        let imageWidth = 20.0
        let imageHeight = 20.0
        imageView.frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        
        let leftViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: imageWidth + 10, height: imageHeight))
        
        imageView.frame.origin.x = 10
        leftViewContainer.addSubview(imageView)
        
        searchField.leftView = leftViewContainer
    }
    
    private func setupFilterButton() {
        filterButton.layer.borderWidth = 1
        filterButton.layer.borderColor = UIColor.clear.cgColor
        filterButton.layer.cornerRadius = 10
        filterButton.backgroundColor = darkGreyColor
    }
}
