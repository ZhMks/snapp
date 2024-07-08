//
//  BookmarkedPost.swift
//  Snapp
//
//  Created by Максим Жуин on 07.07.2024.
//

import UIKit


final class BookmarkedPostCell: UITableViewCell {


        //MARK: -Properties

        static let identifier = "BookmarkedPostCell"

        var user: FirebaseUser?
        var post: BookmarkedPost?
        var likes: [Like]?
        var postcellstate: PostCellState?
        var mainUserID: String?


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
            mainPostView.backgroundColor = ColorCreator.shared.createPostBackgroundColor()
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
            postTextLabel.textAlignment = .left
            postTextLabel.sizeToFit()
            return postTextLabel
        }()

        private lazy var postImage: UIImageView = {
            let postImage = UIImageView()
            postImage.translatesAutoresizingMaskIntoConstraints = false
            postImage.contentMode = .scaleAspectFill
            return postImage
        }()

        private lazy var separatorView: UIView = {
            let separatorView = UIView()
            separatorView.translatesAutoresizingMaskIntoConstraints = false
            separatorView.backgroundColor = .systemGray4
            return separatorView
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

        private lazy var showDetailPost: UIButton = {
            let showDetailPost = UIButton(type: .system)
            showDetailPost.translatesAutoresizingMaskIntoConstraints = false
            showDetailPost.setTitle(.localized(string: "Показать полностью..."), for: .normal)
            showDetailPost.setTitleColor(.systemBlue, for: .normal)
            showDetailPost.isHidden = true
            return showDetailPost
        }()


        // MARK: -Lifecycle

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .default, reuseIdentifier: reuseIdentifier)
            contentView.backgroundColor = ColorCreator.shared.createPostBackgroundColor()
            addSubviews()
            layout()
        }

        override func prepareForReuse() {
            super.prepareForReuse()
            self.postImage.image = nil
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

         deinit {
            print("TableViewCell is deallocated")
        }

        // MARK: -Funcs

        func updateView(post: BookmarkedPost, user: FirebaseUser, state: PostCellState, mainUserID: String) {

            self.post = post
            self.user = user
            self.postcellstate = state
            self.mainUserID = mainUserID

            configureLabels(post: post, user: user, date: post.date)

            fetchComments(for: post, user: user)
            fetchPostImage(for: post)

            if let avatarImageURL = user.image {
                fetchAvatarImage(user: avatarImageURL)
            }
        }

        private func configureLabels(post: BookmarkedPost, user: FirebaseUser, date: String) {
            postTextLabel.text = post.text
            nameAndSurnameLabel.text = "\(user.name) \(user.surname)"
            jobLabel.text = user.job
            dateLabel.text = date
        }

        private func fetchComments(for post: BookmarkedPost, user: FirebaseUser) {
            guard let postID = post.documentID, let userID = user.documentID else { return }

            FireStoreService.shared.getComments(post: postID, user: userID) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let comments):
                    self.commentsLabel.text = "\(comments.count)"
                case .failure(let error):
                    print("Failed to fetch comments: \(error.localizedDescription)")
                }
            }
        }

        private func fetchPostImage(for post: BookmarkedPost) {
            guard let postImageURL = post.image else { return }

            if !postImageURL.isEmpty {
                let networkService = NetworkService()
                networkService.fetchImage(string: postImageURL) { [weak self] result in
                    guard let self = self else { return }

                    switch result {
                    case .success(let image):
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            self.postImage.image = image
                            self.postImage.clipsToBounds = true
                            self.postImage.layer.cornerRadius = 30
                            self.postImage.contentMode = .scaleAspectFill
                        }
                    case .failure(let error):
                        print("Failed to fetch post image: \(error.localizedDescription)")
                    }
                }
            } else {
                return
            }
        }

        private func fetchAvatarImage(user: String) {
            let networkService = NetworkService()
            networkService.fetchImage(string: user) { [weak self] result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async { [weak self] in
                        self?.avatarImageView.image = image
                        self?.avatarImageView.clipsToBounds = true
                        self?.avatarImageView.layer.cornerRadius = (self?.avatarImageView.frame.size.width)! / 2
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
            mainPostView.addSubview(commentsButton)
            mainPostView.addSubview(commentsLabel)
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
                mainPostView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -60),

                verticalView.topAnchor.constraint(equalTo: mainPostView.topAnchor, constant: 5),
                verticalView.leadingAnchor.constraint(equalTo: mainPostView.leadingAnchor, constant: 31),
                verticalView.widthAnchor.constraint(equalToConstant: 1),
                verticalView.bottomAnchor.constraint(equalTo: postImage.bottomAnchor, constant: -16),

                postTextLabel.topAnchor.constraint(equalTo: mainPostView.topAnchor, constant:  5),
                postTextLabel.leadingAnchor.constraint(equalTo: mainPostView.leadingAnchor, constant: 52),
                postTextLabel.trailingAnchor.constraint(equalTo: mainPostView.trailingAnchor, constant: -15),
                postTextLabel.heightAnchor.constraint(equalToConstant: 100),

                postImage.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: 5),
                postImage.leadingAnchor.constraint(equalTo: mainPostView.leadingAnchor, constant: 52),
                postImage.widthAnchor.constraint(equalToConstant: 300),
                postImage.heightAnchor.constraint(equalToConstant: 125),

                separatorView.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: 15),
                separatorView.leadingAnchor.constraint(equalTo: mainPostView.leadingAnchor),
                separatorView.trailingAnchor.constraint(equalTo: mainPostView.trailingAnchor),
                separatorView.heightAnchor.constraint(equalToConstant: 1),

                commentsButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 10),
                commentsButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
                commentsButton.heightAnchor.constraint(equalToConstant: 20),
                commentsButton.widthAnchor.constraint(equalToConstant: 20),

                commentsLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 10),
                commentsLabel.leadingAnchor.constraint(equalTo: commentsButton.trailingAnchor, constant: 10),
                commentsLabel.trailingAnchor.constraint(equalTo: mainPostView.trailingAnchor, constant: -193),
                commentsLabel.heightAnchor.constraint(equalToConstant: 20),

                footerView.topAnchor.constraint(equalTo: mainPostView.bottomAnchor),
                footerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
                footerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
                footerView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),

                leftSeparatorView.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
                leftSeparatorView.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 18),
                leftSeparatorView.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -248),
                leftSeparatorView.heightAnchor.constraint(equalToConstant: 1),

                ellipseView.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 10),
                ellipseView.leadingAnchor.constraint(equalTo: leftSeparatorView.trailingAnchor, constant: 10),
                ellipseView.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -138),
                ellipseView.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -10),

                dateLabel.topAnchor.constraint(equalTo: ellipseView.topAnchor, constant: 3),
                dateLabel.centerXAnchor.constraint(equalTo: ellipseView.centerXAnchor),
                dateLabel.bottomAnchor.constraint(equalTo: ellipseView.bottomAnchor, constant: -3),

                rightSeparatorView.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
                rightSeparatorView.leadingAnchor.constraint(equalTo: ellipseView.trailingAnchor, constant: 10),
                rightSeparatorView.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -16),
                rightSeparatorView.heightAnchor.constraint(equalToConstant: 1)
            ])
        }
    }

