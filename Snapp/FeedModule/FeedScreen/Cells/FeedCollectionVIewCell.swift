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

    private lazy var storieImageView: UIImageView = {
        let storieImageView = UIImageView()
        storieImageView.translatesAutoresizingMaskIntoConstraints = false
        storieImageView.layer.cornerRadius = 12.0
        storieImageView.layer.borderWidth = 1.0
        storieImageView.layer.borderColor = UIColor.systemOrange.cgColor
        storieImageView.clipsToBounds = true
        storieImageView.contentMode = .scaleAspectFill
        storieImageView.layer.masksToBounds = true
        storieImageView.layer.cornerRadius = self.storieImageView.frame.size.width / 2.0
        return storieImageView
    }()


    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        layout()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        storieImageView.image = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Funcs

    func addSubviews() {
        contentView.addSubview(storieImageView)
    }

    func layout() {
        let safeArea = contentView.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            storieImageView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            storieImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            storieImageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            storieImageView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }

    func updateCell(image: UIImage) {
        storieImageView.image = image
    }
}
