//
//  FilesCollectionViewCell.swift
//  Snapp
//
//  Created by Максим Жуин on 12.07.2024.
//

import UIKit


final class FilesCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties

    static let identifier = "FilesCollectionViewCell"
    var buttonTapHandler: ((Any?, String) -> Void)?
    var objectInsideCell: Any?
    var objectName: String?

    private lazy var textFileButton: UIButton = {
        let textFileButton = UIButton(type: .system)
        textFileButton.translatesAutoresizingMaskIntoConstraints = false
        textFileButton.setBackgroundImage(UIImage(systemName: "doc"), for: .normal)
        textFileButton.contentMode = .scaleAspectFill
        textFileButton.clipsToBounds = true
        textFileButton.tintColor = .systemGray
        textFileButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return textFileButton
    }()

    private lazy var imageFileButton: UIButton = {
        let imageFileButton = UIButton(type: .system)
        imageFileButton.translatesAutoresizingMaskIntoConstraints = false
        imageFileButton.clipsToBounds = true
        imageFileButton.layer.masksToBounds = true
        imageFileButton.contentMode = .scaleAspectFill
        imageFileButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return imageFileButton
    }()

    private lazy var downloadImageView: UIImageView = {
        let downloadImageView = UIImageView()
        downloadImageView.translatesAutoresizingMaskIntoConstraints = false
        downloadImageView.image = UIImage(systemName: "arrow.down.circle")
        downloadImageView.tintColor = .systemOrange
        return downloadImageView
    }()

    private lazy var fileName: UILabel = {
        let fileName = UILabel()
        fileName.translatesAutoresizingMaskIntoConstraints = false
        return fileName
    }()

    //MARK: -LifeCycle

    override func prepareForReuse() {
        super.prepareForReuse()
        downloadImageView.image = nil
    }

    // MARK: - Funcs

    func updateDataForCell(object: Any?, name: String) {
        if let object = object as? String {
            self.objectInsideCell = object
            self.objectName = name
            fileName.text = name
            addSubviews(button: textFileButton)
            layout(button: textFileButton)
        }

        if let object = object as? UIImage {
            self.objectInsideCell = object
            self.objectName = name
            fileName.text = name
            imageFileButton.setBackgroundImage(object, for: .normal)
            addSubviews(button: imageFileButton)
            layout(button: imageFileButton)
        }
    }

    private func addSubviews(button: UIButton) {
        contentView.addSubview(button)
        contentView.addSubview(downloadImageView)
        contentView.addSubview(fileName)
    }

    private func layout(button: UIButton) {
        let safeArea = contentView.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5),
            button.widthAnchor.constraint(equalToConstant: 80),
            button.heightAnchor.constraint(equalToConstant: 80),

            downloadImageView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: -15),
            downloadImageView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -5),
            downloadImageView.heightAnchor.constraint(equalToConstant: 20),
            downloadImageView.widthAnchor.constraint(equalToConstant: 20),

            fileName.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 5),
            fileName.heightAnchor.constraint(equalToConstant: 44),
            fileName.widthAnchor.constraint(equalToConstant: 80)
        ])
    }

    @objc func buttonTapped() {
        guard let objectName = self.objectName else { return }
        buttonTapHandler?(objectInsideCell, objectName)
    }
}
