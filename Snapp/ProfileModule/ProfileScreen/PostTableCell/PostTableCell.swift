//
//  PostTableCell.swift
//  Snapp
//
//  Created by Максим Жуин on 03.05.2024.
//

import UIKit


final class PostTableCell: UITableViewCell {

    //MARK: -PROPERTIES
    static let identifier = "PostTableCell"

    private lazy var headerView: UIView = {
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .systemBackground
        return headerView
    }()

    private lazy var footerView: UIView = {
        let footerView = UIView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.backgroundColor = .systemBackground
        return footerView
    }()

    private lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        return avatarImageView
    }()

    private lazy var nameAndSurnameLabel: UILabel = {
        let nameAndSurnameLabel = UILabel()
        nameAndSurnameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameAndSurnameLabel.font = UIFont(name: "Inter-Medium", size: 14)
        nameAndSurnameLabel.textColor = ColorCreator.shared.createTextColor()
        return nameAndSurnameLabel
    }()

    private lazy var jobLabel: UILabel = {
        let jobLabel = UILabel()
        jobLabel.translatesAutoresizingMaskIntoConstraints = false
        jobLabel.font = UIFont(name: "Inter-Medium", size: 14)
        jobLabel.textColor = .systemGray4
        return jobLabel
    }()

    private lazy var mainPostView: UIView = {
        let mainPostView = UIView()
        mainPostView.translatesAutoresizingMaskIntoConstraints = false
        mainPostView.backgroundColor = .systemGray6
        return mainPostView
    }()

    private lazy var verticalView: UIView = {
        let verticalView = UIView()
        verticalView.translatesAutoresizingMaskIntoConstraints = false
        verticalView.backgroundColor = .systemGray
        return verticalView
    }()

    private lazy var postTextLabel: UILabel = {
        let postTextLabel = UILabel()
        postTextLabel.numberOfLines = 0
        postTextLabel.translatesAutoresizingMaskIntoConstraints = false
        postTextLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        postTextLabel.textAlignment = .left
        postTextLabel.sizeToFit()
        return postTextLabel
    }()

    private lazy var postImage: UIImageView = {
        let postImage = UIImageView()
        postImage.translatesAutoresizingMaskIntoConstraints = false
        return postImage
    }()

    private lazy var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .systemGray4
        return separatorView
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
        likesLabel.font = UIFont(name: "Inter-Light", size: 14)
        likesLabel.text = "22"
        likesLabel.textColor = ColorCreator.shared.createTextColor()
        return likesLabel
    }()

    private lazy var commentsButton: UIButton = {
        let commentsButton = UIButton(type: .system)
        commentsButton.translatesAutoresizingMaskIntoConstraints = false
        commentsButton.setBackgroundImage(UIImage(systemName: "bubble"), for: .normal)
        commentsButton.tintColor = ColorCreator.shared.createButtonColor()
        return commentsButton
    }()

    private lazy var commentsLabel: UILabel = {
        let commentsLabel = UILabel()
        commentsLabel.translatesAutoresizingMaskIntoConstraints = false
        commentsLabel.font = UIFont(name: "Inter-Light", size: 14)
        commentsLabel.text = "24"
        commentsLabel.textColor = ColorCreator.shared.createTextColor()
        return commentsLabel
    }()

    private lazy var bookmarkButton: UIButton = {
        let bookmarkButton = UIButton(type: .system)
        bookmarkButton.translatesAutoresizingMaskIntoConstraints = false
        bookmarkButton.setBackgroundImage(UIImage(systemName: "bookmark"), for: .normal)
        bookmarkButton.tintColor = ColorCreator.shared.createButtonColor()
        return bookmarkButton
    }()

    private lazy var leftSeparatorView: UIView = {
        let leftSeparatorView = UIView()
        leftSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        leftSeparatorView.backgroundColor = ColorCreator.shared.createButtonColor()
        return leftSeparatorView
    }()

    private lazy var ellipseView: UIView = {
        let ellipseView = UIView()
        ellipseView.translatesAutoresizingMaskIntoConstraints = false
        ellipseView.layer.cornerRadius = 15.0
        ellipseView.layer.borderWidth = 1.0
        ellipseView.layer.borderColor = ColorCreator.shared.createButtonColor().cgColor
        return ellipseView
    }()

    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont(name: "Inter-Light", size: 14)
        dateLabel.text = "04 июля"
        dateLabel.textColor = ColorCreator.shared.createTextColor()
        return dateLabel
    }()

    private lazy var rightSeparatorView: UIView = {
        let rightSeparatorView = UIView()
        rightSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        rightSeparatorView.backgroundColor = ColorCreator.shared.createButtonColor()
        return rightSeparatorView
    }()


    // MARK: -LIFECYCLE

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        addSubviews()
        layout()
        contentView.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: -FUNCS

    func updateView(post: EachPost, user: FirebaseUser, date: String) {
        postTextLabel.text = post.text
        nameAndSurnameLabel.text = "\(user.name)" + "\(user.surname)"
        jobLabel.text = "\(user.job)"
        likesLabel.text = "\(post.likes)"
        commentsLabel.text = "\(post.views)"
        dateLabel.text = date
        let networkService = NetworkService()
        if let postImage = post.image {
            networkService.fetchImage(string: postImage) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let success):
                    DispatchQueue.main.async {
                        guard let image = UIImage(data: success) else { return }
                        self.postImage.image = image
                        self.postImage.clipsToBounds = true
                        self.postImage.layer.cornerRadius = 30
                    }
                case .failure(_):
                    return
                }
            }
        }
        networkService.fetchImage(string: user.image) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    guard let image = UIImage(data: success) else { return }
                    self.avatarImageView.image = image
                    self.avatarImageView.clipsToBounds = true
                    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.width / 2
                }
            case .failure(_):
                return
            }
        }
    }


    // MARK: -LAYOUT

    private func addSubviews() {

        contentView.addSubview(headerView)
        headerView.addSubview(avatarImageView)
        headerView.addSubview(nameAndSurnameLabel)
        headerView.addSubview(jobLabel)
        contentView.addSubview(mainPostView)
        mainPostView.addSubview(verticalView)
        mainPostView.addSubview(postTextLabel)
        mainPostView.addSubview(postImage)
        mainPostView.addSubview(separatorView)
        mainPostView.addSubview(likesButton)
        mainPostView.addSubview(likesLabel)
        mainPostView.addSubview(commentsButton)
        mainPostView.addSubview(commentsLabel)
        mainPostView.addSubview(bookmarkButton)
        contentView.addSubview(footerView)
        footerView.addSubview(leftSeparatorView)
        footerView.addSubview(ellipseView)
        ellipseView.addSubview(dateLabel)
        footerView.addSubview(rightSeparatorView)
    }

    private func layout() {
        let safeArea = contentView.safeAreaLayoutGuide

        NSLayoutConstraint.activate([

            headerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -390),

            avatarImageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 22),
            avatarImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            avatarImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -12),

            nameAndSurnameLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 22),
            nameAndSurnameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            nameAndSurnameLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -122),
            nameAndSurnameLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -48),

            jobLabel.topAnchor.constraint(equalTo: nameAndSurnameLabel.bottomAnchor, constant: 5),
            jobLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            jobLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -122),
            jobLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -25),

            mainPostView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 5),
            mainPostView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            mainPostView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            mainPostView.heightAnchor.constraint(greaterThanOrEqualToConstant: 380),

            verticalView.topAnchor.constraint(equalTo: mainPostView.topAnchor, constant: 5),
            verticalView.leadingAnchor.constraint(equalTo: mainPostView.leadingAnchor, constant: 31),
            verticalView.trailingAnchor.constraint(equalTo: mainPostView.trailingAnchor, constant: -361),
            verticalView.bottomAnchor.constraint(equalTo: mainPostView.bottomAnchor, constant: -76),

            postTextLabel.topAnchor.constraint(equalTo: mainPostView.topAnchor, constant:  5),
            postTextLabel.leadingAnchor.constraint(equalTo: mainPostView.leadingAnchor, constant: 52),
            postTextLabel.trailingAnchor.constraint(equalTo: mainPostView.trailingAnchor, constant: -15),
            postTextLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),

            postImage.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: 5),
            postImage.leadingAnchor.constraint(equalTo: mainPostView.leadingAnchor, constant: 52),
            postImage.widthAnchor.constraint(equalToConstant: 300),
            postImage.heightAnchor.constraint(greaterThanOrEqualToConstant: 125),

            separatorView.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 15),
            separatorView.leadingAnchor.constraint(equalTo: mainPostView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: mainPostView.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),

            likesButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 10),
            likesButton.leadingAnchor.constraint(equalTo: mainPostView.leadingAnchor, constant: 52),
            likesButton.trailingAnchor.constraint(equalTo: mainPostView.trailingAnchor, constant: -303),
            likesButton.bottomAnchor.constraint(equalTo: mainPostView.bottomAnchor, constant: -5),

            likesLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 10),
            likesLabel.leadingAnchor.constraint(equalTo: likesButton.trailingAnchor, constant: 10),
            likesLabel.trailingAnchor.constraint(equalTo: mainPostView.trailingAnchor, constant: -275),
            likesLabel.bottomAnchor.constraint(equalTo: mainPostView.bottomAnchor, constant: -5),

            commentsButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 10),
            commentsButton.leadingAnchor.constraint(equalTo: likesLabel.trailingAnchor, constant: 30),
            commentsButton.trailingAnchor.constraint(equalTo: mainPostView.trailingAnchor, constant: -221),
            commentsButton.bottomAnchor.constraint(equalTo: mainPostView.bottomAnchor, constant: -5),

            commentsLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 10),
            commentsLabel.leadingAnchor.constraint(equalTo: commentsButton.trailingAnchor, constant: 10),
            commentsLabel.trailingAnchor.constraint(equalTo: mainPostView.trailingAnchor, constant: -193),
            commentsLabel.bottomAnchor.constraint(equalTo: mainPostView.bottomAnchor, constant: -5),

            bookmarkButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 10),
            bookmarkButton.leadingAnchor.constraint(equalTo: commentsLabel.trailingAnchor, constant: 151),
            bookmarkButton.trailingAnchor.constraint(equalTo: mainPostView.trailingAnchor, constant: -18),
            bookmarkButton.bottomAnchor.constraint(equalTo: mainPostView.bottomAnchor, constant: -5),

            footerView.topAnchor.constraint(equalTo: mainPostView.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),

            leftSeparatorView.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 24),
            leftSeparatorView.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 18),
            leftSeparatorView.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -248),
            leftSeparatorView.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -24),

            ellipseView.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 10),
            ellipseView.leadingAnchor.constraint(equalTo: leftSeparatorView.trailingAnchor, constant: 10),
            ellipseView.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -138),
            ellipseView.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -10),

            dateLabel.topAnchor.constraint(equalTo: ellipseView.topAnchor, constant: 3),
            dateLabel.leadingAnchor.constraint(equalTo: ellipseView.leadingAnchor, constant: 15),
            dateLabel.trailingAnchor.constraint(equalTo: ellipseView.trailingAnchor, constant: -15),
            dateLabel.bottomAnchor.constraint(equalTo: ellipseView.bottomAnchor, constant: -3),

            rightSeparatorView.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 24),
            rightSeparatorView.leadingAnchor.constraint(equalTo: ellipseView.trailingAnchor, constant: 10),
            rightSeparatorView.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
            rightSeparatorView.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -24),

        ])
    }

}
