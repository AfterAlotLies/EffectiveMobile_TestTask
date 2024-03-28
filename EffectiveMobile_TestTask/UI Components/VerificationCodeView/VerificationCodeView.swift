//
//  VerificationCodeView.swift
//  EffectiveMobile_TestTask
//
//  Created by Vyacheslav on 28.03.2024.
//

import UIKit

// MARK: - VerificationCodeView class
class VerificationCodeView: UIView {
    
    @IBOutlet private weak var confirmLabel: UILabel!
    @IBOutlet private weak var codeVerificationField: UICollectionView!
    @IBOutlet private weak var confirmButton: UIButton!
    
    private let countOfInputs: Int = 4
    private var confirmActionHandler: (() -> Void)?
    private var textInput: String = ""
    
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
        guard let view = Bundle.main.loadNibNamed("VerificationCodeView", owner: self)?.first as? UIView else {
            return UIView()
        }
        return view
    }
    
    // MARK: - Public methods
    func setConfirmActionHandler(_ actionHandler: (() -> Void)?) {
        confirmActionHandler = actionHandler
    }
    
    // MARK: - IBAction
    @IBAction func confirmButtonAction(_ sender: Any) {
        confirmActionHandler?()
    }
    
    // MARK: - Private methods
    private func configureView() {
        let subview = self.loadViewFromXib()
        subview.frame = self.bounds
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(subview)
        setupConfirmLabel()
        setupCodeFieldCollection()
        setupConfirmButton()
    }
    
    private func setupConfirmButton() {
        confirmButton.backgroundColor = .systemBlue
        confirmButton.layer.cornerRadius = 5
        confirmButton.isUserInteractionEnabled = false
        confirmButton.alpha = 0.5
    }
    
    private func setupConfirmLabel() {
        confirmLabel.numberOfLines = 0
        confirmLabel.lineBreakMode = .byWordWrapping
    }
    
    private func setupCodeFieldCollection() {
        let codeFieldCell = UINib(nibName: "VerificationCodeCell", bundle: nil)
        codeVerificationField.register(codeFieldCell, forCellWithReuseIdentifier: "verificationCodeField")
        
        codeVerificationField.dataSource = self
        
        codeVerificationField.backgroundColor = .clear
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 65, height: 65)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: -10, bottom: 10, right: 10)
        layout.collectionView?.contentInsetAdjustmentBehavior = .never
        
        codeVerificationField.collectionViewLayout = layout
    }
}

// MARK: - VerificationCodeView + UICollectionViewDataSource
extension VerificationCodeView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countOfInputs
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let codeCell = codeVerificationField.dequeueReusableCell(withReuseIdentifier: "verificationCodeField", for: indexPath) as? VerificationCodeCell else {
            return UICollectionViewCell()
        }
        codeCell.verificationCodeViewDelegate = self
        return codeCell
    }
}

// MARK: - VerificationCodeView + VerificationCodeViewDelegate
extension VerificationCodeView: VerificationCodeViewDelegate {
    
    func switchTextField(in cell: VerificationCodeCell) {
        guard let indexPath = codeVerificationField.indexPath(for: cell) else { return }
        
        let nextItem = indexPath.item + 1
        
        if nextItem < countOfInputs {
            let nextIndexPath = IndexPath(item: nextItem, section: indexPath.section)
            guard let nextCell = codeVerificationField.cellForItem(at: nextIndexPath) as? VerificationCodeCell else { return }
            nextCell.setInputFirstResponder()
        }
        
        if indexPath.item == countOfInputs - 1 && textInput != "" {
            confirmButton.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.3) {
                self.confirmButton.alpha = 1
            }
        } else {
            confirmButton.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.3) {
                self.confirmButton.alpha = 0.5
            }
        }
    }
    
    func isLastEmpty(text: String) {
        textInput = text
    }
    
    func deactivateConfirmButton() {
        confirmButton.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3) {
            self.confirmButton.alpha = 0.5
        }
    }
}
