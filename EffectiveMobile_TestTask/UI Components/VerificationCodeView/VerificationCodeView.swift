//
//  VerificationCodeView.swift
//  EffectiveMobile_TestTask
//
//  Created by Vyacheslav on 28.03.2024.
//

import UIKit

class VerificationCodeView: UIView {
    
    @IBOutlet private weak var confirmLabel: UILabel!
    @IBOutlet private weak var codeVerificationField: UICollectionView!
    @IBOutlet private weak var confirmButton: UIButton!
    
    private var confirmActionHandler: (() -> Void)?
    
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
    
    private func configureView() {
        let subview = self.loadViewFromXib()
        subview.frame = self.bounds
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(subview)
        setupConfirmLabel()
        setupCodeFieldCollection()
        setupConfirmButton()
    }
    
    func setConfirmActionHandler(_ actionHandler: (() -> Void)?) {
        confirmActionHandler = actionHandler
    }
    
    private func setupConfirmButton() {
        confirmButton.backgroundColor = .systemBlue
        confirmButton.layer.cornerRadius = 5
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
    
    
    @IBAction func confirmButtonAction(_ sender: Any) {
        confirmActionHandler?()
    }
}

extension VerificationCodeView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let codeCell = codeVerificationField.dequeueReusableCell(withReuseIdentifier: "verificationCodeField", for: indexPath) as? VerificationCodeCell else {
            return UICollectionViewCell()
        }
        return codeCell
    }
}
