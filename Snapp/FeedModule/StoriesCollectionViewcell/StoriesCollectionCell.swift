//
//  StoriesCollectionCell.swift
//  Snapp
//
//  Created by Максим Жуин on 16.07.2024.
//

import UIKit

final class StoriesCollectionCell: UICollectionViewCell {

    static let id = "StoriesCollectionCell"

    private lazy var subStorieImage: UIImageView = {
        let subStorieImage = UIImageView()
        subStorieImage.translatesAutoresizingMaskIntoConstraints = false
        return subStorieImage
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addCustomSubviews()
        layoutCustomSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func addCustomSubviews() {
        contentView.addSubview(subStorieImage)
    }

    func layoutCustomSubviews() {
        let safeArea = contentView.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            subStorieImage.topAnchor.constraint(equalTo: safeArea.topAnchor),
            subStorieImage.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            subStorieImage.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            subStorieImage.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }

    func updateCellData(image: UIImage) {
        self.subStorieImage.image = image
        subStorieImage.clipsToBounds = true
        subStorieImage.layer.masksToBounds = true
        subStorieImage.layer.cornerRadius = subStorieImage.frame.size.width / 2
        subStorieImage.contentMode = .scaleAspectFill
        subStorieImage.layer.borderWidth = 1.0
        subStorieImage.layer.borderColor = UIColor.systemOrange.cgColor
    }

}
