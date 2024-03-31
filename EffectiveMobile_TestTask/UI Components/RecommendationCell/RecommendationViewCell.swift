//
//  RecommendationViewCell.swift
//  EffectiveMobile_TestTask
//
//  Created by Vyacheslav on 29.03.2024.
//

import UIKit

class RecommendationViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var backgroundViewCell: UIView!
    @IBOutlet private weak var recommendImage: UIImageView!
    @IBOutlet private weak var recommendLabel: UILabel!
    @IBOutlet private weak var recommendUpButton: UIButton!
    
    private let darkGreyColor: UIColor = UIColor(red: 34.0 / 255.0, green: 35.0 / 255.0, blue: 37.0 / 255.0, alpha: 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBackgroundCell()
    }
    
    func setImage(imageName: String) {
        recommendImage.image = UIImage(named: imageName)
    }
    
    func setRecommendText(text: String) {
        recommendLabel.text = text
        recommendLabel.textColor = .white
    }
    
    func setRecommendUpButton(text: String) {
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        let attributedQuote = NSAttributedString(string: text, attributes: attributes as [NSAttributedString.Key : Any])
        
        recommendUpButton.setAttributedTitle(attributedQuote, for: .normal)
        recommendUpButton.tintColor = .systemGreen
    }
    
    func hideButton() {
        recommendUpButton.isHidden = true
    }
    
    private func setupBackgroundCell() {
        backgroundViewCell.layer.borderWidth = 1
        backgroundViewCell.layer.borderColor = UIColor.clear.cgColor
        backgroundViewCell.layer.cornerRadius = 10
        backgroundViewCell.backgroundColor = darkGreyColor
    }
    
}
