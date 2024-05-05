//
//  HeaderTableCell.swift
//  Snapp
//
//  Created by Максим Жуин on 04.05.2024.
//

import UIKit


final class HeaderTableCell: UITableViewCell {

    static let identifier = "HeaderTableCell"

    private lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        return avatarImageView
    }()

    private lazy var nameAndSurnameLabel: UILabel = {
        let nameAndSurnameLabel = UILabel()
        nameAndSurnameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameAndSurnameLabel.textColor = ColorCreator.shared.createTextColor()
        return nameAndSurnameLabel
    }()

    private lazy var jobLabel: UILabel = {
        let jobLabel = UILabel()
        jobLabel.translatesAutoresizingMaskIntoConstraints = false
        jobLabel.textColor = .systemGray2
        return jobLabel
    }()

    private lazy var dottedButton: UIButton = {
        let dottedButton = UIButton(type: .system)
        dottedButton.tintColor = .systemOrange
        dottedButton.setBackgroundImage(UIImage(named: "menu"), for: .normal)
        dottedButton.translatesAutoresizingMaskIntoConstraints = false
        return dottedButton
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemBackground
        addSubViews()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateView(user: FirebaseUser, image: UIImage) {
        avatarImageView.image = image
        nameAndSurnameLabel.text = "\(user.name)" + " \(user.surname)"
        jobLabel.text = "\(user.job)"
    }

    func addSubViews() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameAndSurnameLabel)
        contentView.addSubview(jobLabel)
        contentView.addSubview(dottedButton)
    }

    func layout() {
        let safeArea = contentView.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 26),
            avatarImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            avatarImageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -300),
            avatarImageView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -12),

            nameAndSurnameLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30),
            nameAndSurnameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 100),
            nameAndSurnameLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -123),
            nameAndSurnameLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -48),

            jobLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 53),
            jobLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 100),
            jobLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -208),
            jobLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -25),

            dottedButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 38),
            dottedButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 345),
            dottedButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24),
            dottedButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -39)
        ])
    }
}
