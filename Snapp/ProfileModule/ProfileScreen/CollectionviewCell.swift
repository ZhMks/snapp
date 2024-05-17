//
//  CollectionviewCell.swift
//  Snapp
//
//  Created by Максим Жуин on 15.05.2024.
//

import UIKit

final class ProfileCollectionViewCell: UICollectionViewCell {

static let identifier = "ProfileCollectionViewCell"

    private lazy var photoImageView: UIImageView = {
        let photoImageView = UIImageView()
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.layer.cornerRadius = 20
        photoImageView.clipsToBounds = true
        return photoImageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        layoutViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        contentView.addSubview(photoImageView)
    }

    func layoutViews() {
        let safeArea = contentView.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }

    func updateView(image: UIImage) {
        self.photoImageView.image = image
    }
}
