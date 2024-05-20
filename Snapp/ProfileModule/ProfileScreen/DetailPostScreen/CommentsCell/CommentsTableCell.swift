//
//  CommentsTableCell.swift
//  Snapp
//
//  Created by Максим Жуин on 14.05.2024.
//

import UIKit

final class CommentsTableCell: UITableViewCell {

    // MARK: -PROPERTIES

    static let identifier = "CommentsTableCell"

    var buttonTappedHandler: (()->Void)?

    let networkService = NetworkService()

    private lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.clipsToBounds = true
        return avatarImageView
    }()

    private lazy var identifierLabel: UILabel = {
        let identifierLabel = UILabel()
        identifierLabel.translatesAutoresizingMaskIntoConstraints = false
        identifierLabel.font = UIFont(name: "Inter-Light", size: 12)
        identifierLabel.textColor = .systemOrange
        return identifierLabel
    }()

    private lazy var likesButton: UIButton = {
        let likesButton = UIButton(type: .system)
        likesButton.translatesAutoresizingMaskIntoConstraints = false
        likesButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        likesButton.tintColor = ColorCreator.shared.createButtonColor()
        return likesButton
    }()

    private lazy var likesLabel: UILabel = {
        let likesLabel = UILabel()
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        likesLabel.font = UIFont(name: "Inter-Light", size: 12)
        likesLabel.textColor = .systemGray4
        return likesLabel
    }()

    private lazy var commentLabel: UILabel = {
        let commentLabel = UILabel()
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.font = UIFont(name: "Inter-Light", size: 12)
        commentLabel.textColor = .systemGray4
        return commentLabel
    }()

    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont(name: "Inter-Light", size: 12)
        dateLabel.textColor = .systemGray5
        return dateLabel
    }()

    private lazy var answerButton: UIButton = {
        let answerButton = UIButton(type: .system)
        answerButton.translatesAutoresizingMaskIntoConstraints = false
        answerButton.setTitle(.localized(string: "Ответить"), for: .normal)
        answerButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        answerButton.addTarget(self, action: #selector(answerButtonTapped(_:)), for: .touchUpInside)
        return answerButton
    }()



    // MARK: -LIFECYCLE

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        addSubviews()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: -FUNCS

    func updateView(comment: Comment, firestoreService: FireStoreServiceProtocol) {

        commentLabel.text = comment.text
        dateLabel.text = comment.date
        likesLabel.text = "\(comment.likes)"

        firestoreService.getUser(id: comment.commentor) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                identifierLabel.text = user.identifier
                networkService.fetchImage(string: user.image) { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success(let success):
                        guard let image = UIImage(data: success) else { return }
                        DispatchQueue.main.async {
                            self.avatarImageView.image = image
                            self.avatarImageView.clipsToBounds = true
                            self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2
                        }
                    case .failure(let failure):
                        print(failure.localizedDescription)
                    }
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }

    func updateAnswers(answer: Answer, user: FirebaseUser, date: String, firestoreService: FireStoreServiceProtocol) {
        commentLabel.text = answer.text
        dateLabel.text = answer.date
        likesLabel.text = "\(answer.likes)"

        firestoreService.getUser(id: answer.commentor) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                identifierLabel.text = user.identifier
                networkService.fetchImage(string: user.image) { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success(let success):
                        guard let image = UIImage(data: success) else { return }
                        DispatchQueue.main.async {
                            self.avatarImageView.image = image
                            self.avatarImageView.clipsToBounds = true
                            self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2
                        }
                    case .failure(let failure):
                        print(failure.localizedDescription)
                    }
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }

    @objc func answerButtonTapped(_ sender: UIButton) {
        buttonTappedHandler?()
    }

    // MARK: -LAYOUT

    func addSubviews() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(identifierLabel)
        contentView.addSubview(likesButton)
        contentView.addSubview(likesLabel)
        contentView.addSubview(commentLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(answerButton)
    }

    func layout() {
        let safeArea = contentView.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 38),
            avatarImageView.heightAnchor.constraint(equalToConstant: 15),
            avatarImageView.widthAnchor.constraint(equalToConstant: 15),

            identifierLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            identifierLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 7),
            identifierLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -180),
            identifierLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -33),

            likesButton.topAnchor.constraint(equalTo: safeArea.topAnchor),
            likesButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -17),
            likesButton.heightAnchor.constraint(equalToConstant: 15),
            likesButton.widthAnchor.constraint(equalToConstant: 15),

            likesLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            likesLabel.leadingAnchor.constraint(equalTo: likesButton.trailingAnchor, constant: 5),
            likesLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5),
            likesLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -33),

            commentLabel.topAnchor.constraint(equalTo: identifierLabel.bottomAnchor, constant: 3),
            commentLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 60),
            commentLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -80),
            commentLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -15),

            dateLabel.topAnchor.constraint(equalTo: commentLabel.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 60),
            dateLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -80),
            dateLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),

            answerButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 33),
            answerButton.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 90),
            answerButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            answerButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}