//
//  PostTableCell.swift
//  Snapp
//
//  Created by Максим Жуин on 03.05.2024.
//

import UIKit

enum PostCellState {
    case feedState
    case profileState
}

final class PostTableCell: UITableViewCell {

    //MARK: -Properties
    static let identifier = "PostTableCell"

    var manuButtonTappedHandler: (() -> Void)?
    var incrementLikes: ((_ post: String) -> Void)?
    var decrementLikes: ((_ post: String) -> Void)?
    var showMenuForFeed: ((_ post: EachPost) -> Void)?
    var bookmarkButtonTapHandler: ((EachPost) -> Void)?



    var user: FirebaseUser?
    var post: EachPost?
    var likes: [Like]?
    var firestoreService: FireStoreServiceProtocol?
    var postcellstate: PostCellState?
    let menuForPost = MenuForPostView()
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

    private lazy var menuButton: UIButton = {
        let menuButton = UIButton(type: .system)
        menuButton.setBackgroundImage(UIImage(named: "menu"), for: .normal)
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        menuButton.tintColor = .systemOrange
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        return menuButton
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

    private lazy var likesButton: UIButton = {
        let likesButton = UIButton(type: .system)
        likesButton.translatesAutoresizingMaskIntoConstraints = false
        likesButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        likesButton.tintColor = ColorCreator.shared.createButtonColor()
        likesButton.addTarget(self, action: #selector(likesButtonTapped), for: .touchUpInside)
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
        bookmarkButton.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

     deinit {
        print("Cell is deallocated")
    }
    // MARK: -Funcs

    @objc func likesButtonTapped() {
        guard let post = self.post?.documentID else { return }
        if self.likesButton.backgroundImage(for: .normal) == UIImage(systemName: "heart.fill") {
            decrementLikes?(post)
            self.likesButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        }
        else {
            incrementLikes?(post)
            self.likesButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }

    func updateView(post: EachPost, user: FirebaseUser, date: String, firestoreService: FireStoreServiceProtocol, state: PostCellState, mainUserID: String) {
        self.post = post
        self.user = user
        self.firestoreService = firestoreService
        self.postcellstate = state
        self.mainUserID = mainUserID

        configureLabels(post: post, user: user, date: date)

        fetchComments(for: post, user: user)
        fetchPostImage(for: post)
        fetchAvatarImage(for: user)
        fetchLikes(for: post, user: user)
    }

    private func configureLabels(post: EachPost, user: FirebaseUser, date: String) {
        postTextLabel.text = post.text
        nameAndSurnameLabel.text = "\(user.name) \(user.surname)"
        jobLabel.text = user.job
        dateLabel.text = date
    }

    private func fetchComments(for post: EachPost, user: FirebaseUser) {
        guard let postID = post.documentID, let userID = user.documentID else { return }

        firestoreService?.getComments(post: postID, user: userID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let comments):
                self.commentsLabel.text = "\(comments.count)"
            case .failure(let error):
                print("Failed to fetch comments: \(error.localizedDescription)")
            }
        }
    }

    private func fetchPostImage(for post: EachPost) {
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

    private func fetchAvatarImage(for user: FirebaseUser) {
        guard let avatarImageURL = user.image else { return }

        let networkService = NetworkService()
        networkService.fetchImage(string: avatarImageURL) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let image):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.avatarImageView.image = image
                    self.avatarImageView.clipsToBounds = true
                    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.width / 2
                }
            case .failure(let error):
                print("Failed to fetch avatar image: \(error.localizedDescription)")
            }
        }
    }

    private func fetchLikes(for post: EachPost, user: FirebaseUser) {
        guard let postID = post.documentID, let userID = user.documentID else { return }
        
        firestoreService?.getNumberOfLikesInpost(user: userID, post: postID) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let likes):
                if likes.isEmpty {
                    self.likes = likes
                    self.likesLabel.text = "\(likes.count)"
                    likesButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
                } else {
                    for like in likes {
                        if like.documentID! == mainUserID {
                            self.likes = likes
                            self.likesLabel.text = "\(likes.count)"
                            likesButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
                        } else {
                            self.likes = likes
                            self.likesLabel.text = "\(likes.count)"
                        }
                    }
                }
            case .failure(let error):
                print("Failed to fetch likes: \(error.localizedDescription)")
            }
        }
    }


    private func showMenu() {
        menuForPost.isHidden = false
        menuForPost.translatesAutoresizingMaskIntoConstraints = false
        guard let user = self.user, let firestoreService = self.firestoreService, let post = self.post else { return }
        let presenter = MenuForPostPresenter(view: menuForPost, user: user, firestoreService: firestoreService, post: post)
        menuForPost.presenter = presenter

        menuForPost.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        menuForPost.layer.shadowOpacity = 1.0
        menuForPost.layer.shadowColor = UIColor.systemGray5.cgColor

        contentView.addSubview(menuForPost)
        let safeArea = contentView.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            menuForPost.topAnchor.constraint(equalTo: safeArea.topAnchor),
            menuForPost.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 57),
            menuForPost.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -19),
            menuForPost.heightAnchor.constraint(equalToConstant: 300)
        ])
    }

    @objc func menuButtonTapped() {
        guard let post = self.post else { return }
        switch self.postcellstate {
        case .feedState:
            showMenuForFeed?(post)
        case .profileState:
            showMenu()
        default:
            return
        }
    }


    @objc func bookmarkButtonTapped() {
        guard let post = self.post else { return }
        bookmarkButtonTapHandler?(post)
    }


    // MARK: -LAYOUT

    private func addSubviews() {
        menuForPost.isHidden = true
        contentView.addSubview(headerView)
        headerView.addSubview(avatarImageView)
        headerView.addSubview(nameAndSurnameLabel)
        headerView.addSubview(jobLabel)
        headerView.addSubview(menuButton)
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

            menuButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 38),
            menuButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 350),
            menuButton.widthAnchor.constraint(equalToConstant: 12),
            menuButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -23),

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

            likesButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 10),
            likesButton.leadingAnchor.constraint(equalTo: mainPostView.leadingAnchor, constant: 52),
            likesButton.heightAnchor.constraint(equalToConstant: 20),
            likesButton.widthAnchor.constraint(equalToConstant: 20),

            likesLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 10),
            likesLabel.leadingAnchor.constraint(equalTo: likesButton.trailingAnchor, constant: 10),
            likesLabel.trailingAnchor.constraint(equalTo: mainPostView.trailingAnchor, constant: -275),
            likesLabel.heightAnchor.constraint(equalToConstant: 20),

            commentsButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 10),
            commentsButton.leadingAnchor.constraint(equalTo: likesLabel.trailingAnchor, constant: 30),
            commentsButton.heightAnchor.constraint(equalToConstant: 20),
            commentsButton.widthAnchor.constraint(equalToConstant: 20),

            commentsLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 10),
            commentsLabel.leadingAnchor.constraint(equalTo: commentsButton.trailingAnchor, constant: 10),
            commentsLabel.trailingAnchor.constraint(equalTo: mainPostView.trailingAnchor, constant: -193),
            commentsLabel.heightAnchor.constraint(equalToConstant: 20),

            bookmarkButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 10),
            bookmarkButton.leadingAnchor.constraint(equalTo: commentsLabel.trailingAnchor, constant: 151),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 20),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 20),

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

extension PostTableCell: MenuForPostDelegate {

    func pinPost(post: EachPost) {
        manuButtonTappedHandler?()
    }
}
