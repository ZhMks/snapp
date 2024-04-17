//
//  FeedCollectionVIewCell.swift
//  Snapp
//
//  Created by Максим Жуин on 08.04.2024.
//

import UIKit

final class FeedCollectionViewCell: UICollectionViewCell {

    static let identifier = "FeedCollectionViewCell"

    private lazy var storieImage: UIImageView = {
        let storieImage = UIImageView()
        storieImage.translatesAutoresizingMaskIntoConstraints = false
        storieImage.layer.cornerRadius = 12.0
        storieImage.layer.borderWidth = 1.0
        storieImage.layer.borderColor = ColorCreator.shared.createButtonColor().cgColor
        return storieImage
    }()

    func updateCell(image: UIImage) {
        self.storieImage.image = image
    }
}
