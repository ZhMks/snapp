//
//  FeedCollectionVIewCell.swift
//  Snapp
//
//  Created by Максим Жуин on 08.04.2024.
//

import UIKit

final class FeedCollectionViewCell: UICollectionViewCell {

    // MARK - Properties

    static let identifier = "FeedCollectionViewCell"

    private lazy var storieImage: UIImageView = {
        let storieImage = UIImageView()
        storieImage.translatesAutoresizingMaskIntoConstraints = false
        storieImage.layer.cornerRadius = 12.0
        storieImage.layer.borderWidth = 1.0
        storieImage.layer.borderColor = UIColor.systemOrange.cgColor
        storieImage.clipsToBounds = true
        storieImage.contentMode = .scaleAspectFill
        storieImage.layer.masksToBounds = true
        storieImage.layer.cornerRadius = self.storieImage.frame.size.width / 2.0
        return storieImage
    }()


    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        layout()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        storieImage.image = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Funcs

    func addSubviews() {
        contentView.addSubview(storieImage)
    }

    func layout() {
        let safeArea = contentView.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            storieImage.topAnchor.constraint(equalTo: safeArea.topAnchor),
            storieImage.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            storieImage.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            storieImage.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }

    func updateCell(image: UIImage) {
        self.storieImage.image = image
    }
}
