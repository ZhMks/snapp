//
//  DetailPostViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 14.05.2024.
//

import UIKit
import FirebaseAuth

enum PostMenuState {
    case feedPost
    case detailPost
}

class DetailPostViewController: UIViewController {

    // MARK: -Properties
    var presenter: DetailPostPresenter!
    var postMenuState: PostMenuState?
    let menuForPost = MenuForPostView()

    private lazy var detailPostView: UIView = {
        let detailPostView = UIView()
        detailPostView.backgroundColor = .systemBackground

        return detailPostView
    }()
    private lazy var topSeparatorView: UIView = {
        let topSeparatorView = UIView()
        topSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        topSeparatorView.backgroundColor = .systemGray4

        return topSeparatorView
    }()

    private lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.image = presenter.avatarImage
        avatarImageView.clipsToBounds = true

        return avatarImageView
    }()

    private lazy var identifierLabel: UILabel = {
        let identifierLabel = UILabel()
        identifierLabel.translatesAutoresizingMaskIntoConstraints = false
        identifierLabel.font = UIFont(name: "Inter-Light", size: 12)
        identifierLabel.textColor = .systemOrange
        identifierLabel.text = presenter.user.identifier

        return identifierLabel
    }()

    private lazy var jobLabel: UILabel = {
        let jobLabel = UILabel()
        jobLabel.translatesAutoresizingMaskIntoConstraints = false
        jobLabel.textColor = .systemGray3
        jobLabel.font = UIFont(name: "Inter-Light", size: 12)
        jobLabel.text = presenter.user.job

        return jobLabel
    }()

    private lazy var postImageView: UIImageView = {
        let postImageView = UIImageView()
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        return postImageView
    }()

    private lazy var postTextLabel: UILabel = {
        let postTextLabel = UILabel()
        postTextLabel.translatesAutoresizingMaskIntoConstraints = false
        postTextLabel.font = UIFont(name: "Inter-Light", size: 14)
        postTextLabel.textColor = ColorCreator.shared.createTextColor()
        postTextLabel.text = presenter.post.text
        postTextLabel.numberOfLines = 0
        postTextLabel.textAlignment = .left
        postTextLabel.sizeToFit()

        return postTextLabel
    }()

    private lazy var likeButton: UIButton = {
        let likeButton = UIButton(type: .system)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.clipsToBounds = true
        likeButton.tintColor = ColorCreator.shared.createButtonColor()
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)

        return likeButton
    }()

    private lazy var likesLabel: UILabel = {
        let likesLabel = UILabel()
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        likesLabel.font = UIFont(name: "Inter-Light", size: 14)
        likesLabel.textColor = ColorCreator.shared.createTextColor()
        likesLabel.text = .localized(string: "\(presenter.post.likes)")

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
        commentsLabel.textColor = ColorCreator.shared.createTextColor()
        commentsLabel.text = .localized(string: "\(presenter.post.commentaries)")

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

    private lazy var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .systemGray5
        return separatorView
    }()

    private lazy var tableViewTitle: UILabel = {
        let tableViewTitle = UILabel()
        tableViewTitle.translatesAutoresizingMaskIntoConstraints = false
        tableViewTitle.font = UIFont(name: "Inter-Light", size: 14)
        tableViewTitle.textColor = .systemGray4
        tableViewTitle.text = .localized(string: "Комментарии \(presenter.post.commentaries)")
        tableViewTitle.sizeToFit()
        tableViewTitle.numberOfLines = 0
        return tableViewTitle
    }()

    private lazy var commentsTableView: UITableView = {
        let commentsTableView = UITableView()
        commentsTableView.translatesAutoresizingMaskIntoConstraints = false
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        return commentsTableView
    }()

    private lazy var addCommentView: UIView = {
        let addCommentView = UIView()
        addCommentView.translatesAutoresizingMaskIntoConstraints = false
        addCommentView.backgroundColor = ColorCreator.shared.createPostBackgroundColor()
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(addCommentTapped))
        tapgesture.numberOfTapsRequired = 1
        addCommentView.addGestureRecognizer(tapgesture)
        return addCommentView
    }()

    private lazy var addCommentImage: UIImageView = {
        let addCommentImage = UIImageView()
        addCommentImage.translatesAutoresizingMaskIntoConstraints = false
        addCommentImage.image = UIImage(systemName: "paperclip")
        addCommentImage.tintColor = ColorCreator.shared.createButtonColor()
        return addCommentImage
    }()

    private lazy var addCommentLabel: UILabel = {
        let addCommentLabel = UILabel()
        addCommentLabel.translatesAutoresizingMaskIntoConstraints = false
        addCommentLabel.font = UIFont(name: "Inter-Light", size: 12)
        addCommentLabel.textColor = .systemGray4
        addCommentLabel.text = .localized(string: "Оставить комментарий")
        return addCommentLabel
    }()

    // MARK: -Lifecycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.fetchComments()
        presenter.getLikes()
        presenter.checkBookmarkedPost()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addTapGesture()
        tuneNavItem()
        presenter.fetchPostImage()
    }

    // MARK: -Funcs
    private func tuneNavItem() {
        let settingsButton = UIBarButtonItem(image: UIImage(named: "menu"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(showSettingsVC))
        settingsButton.tintColor = .systemOrange
        self.navigationItem.rightBarButtonItem = settingsButton

        let textView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 30))

        let title = UILabel(frame: CGRect(x: 40, y: 0, width: 100, height: 30))
        title.text = .localized(string: "Публикации")
        title.font = UIFont(name: "Inter-Medium", size: 14)

        let leftArrowButton = UIButton(type: .system)
        leftArrowButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        leftArrowButton.setBackgroundImage(UIImage(systemName: "arrow.left"), for: .normal)
        leftArrowButton.tintColor = .systemOrange
        leftArrowButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)

        textView.addSubview(title)
        textView.addSubview(leftArrowButton)
        let leftButton = UIBarButtonItem(customView: textView)
        self.navigationItem.leftBarButtonItem = leftButton
    }

    @objc func likeButtonTapped() {

        if self.likeButton.backgroundImage(for: .normal) == UIImage(systemName: "heart.fill") {
            presenter.decrementLikesForPost()
            self.likeButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        }
        else {
            presenter.incrementLikesForPost()
            self.likeButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }

    @objc func showSettingsVC() {
        switch postMenuState {
        case .feedPost:
            let menuForFeed = MenuForFeedViewController()
            let menuForFeedPresenter = MenuForFeedPresenter(view: menuForFeed, user: self.presenter.user, post: self.presenter.post, mainUserID: self.presenter.mainUserID)
            menuForFeed.presenter = menuForFeedPresenter
            menuForFeed.modalPresentationStyle = .formSheet
            if let sheet = menuForFeed.sheetPresentationController {
                let customHeight = UISheetPresentationController.Detent.custom(identifier: .init("customHeight")) { context in
                    return 300
                }
                sheet.detents = [customHeight]
                sheet.largestUndimmedDetentIdentifier = .some(customHeight.identifier)
            }
            self.navigationController?.present(menuForFeed, animated: true)
        case .detailPost:
            self.presenter.showMenuForPost()
        case nil:
            return
        }
    }

    @objc func dismissViewController() {
        self.navigationController?.popViewController(animated: true)
    }

    private func tuneTableView() {
        commentsTableView.register(CommentsTableCell.self, forCellReuseIdentifier: CommentsTableCell.identifier)
        commentsTableView.register(AnswersTableCell.self, forCellReuseIdentifier: AnswersTableCell.identifier)
        commentsTableView.rowHeight = UITableView.automaticDimension
        commentsTableView.estimatedRowHeight = 44.0
        commentsTableView.setAndLayout(header: detailPostView)

        commentsTableView.tableFooterView = UIView()
        commentsTableView.separatorStyle = .none
        self.commentsTableView.reloadData()
    }

    private func updateAvatarImage() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
    }

    @objc func addCommentTapped() {
        let commentView = CommentViewController()
        guard let documentID = presenter.post.documentID else { return }
        switch self.presenter.userState {
        case .mainUser:
            let commentPresenter = CommentViewPresenter(view: commentView, image: presenter.avatarImage, user: self.presenter.mainUserID, documentID: documentID, commentor: self.presenter.mainUserID, state: .comment, userState: self.presenter.userState)
            commentView.presenter = commentPresenter
            commentView.modalPresentationStyle = .fullScreen
            present(commentView, animated: true)
        case .notMainUser:
            guard let user = presenter.user.documentID else { return }
            let commentPresenter = CommentViewPresenter(view: commentView, image: presenter.avatarImage, user: user, documentID: documentID, commentor: self.presenter.mainUserID, state: .comment, userState: self.presenter.userState)
            commentView.presenter = commentPresenter
            commentView.modalPresentationStyle = .fullScreen
            present(commentView, animated: true)
        }
    }

    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeMenuView))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
    }

    @objc func removeMenuView() {
        menuForPost.removeFromSuperview()
    }

    @objc func bookmarkButtonTapped() {
        presenter.addPostToBookmarks()
    }
}


// MARK: -Output Presenter
extension DetailPostViewController: DetailPostViewProtocol {
    
    func updateBookmarkButton() {
        self.bookmarkButton.tintColor = .systemOrange
    }
    

    func showViewControllerWithoutImage() {
        addSubviewsWithoutImage()
        layoutSubviewsWithoutImage()
        tuneTableView()
        updateAvatarImage()
    }

    func showMenuForPost() {
        let menuForPostPresenter = MenuForPostPresenter(view: menuForPost, user: self.presenter.user, post: self.presenter.post, mainUserID: self.presenter.mainUserID)
        menuForPost.presenter = menuForPostPresenter
        menuForPost.translatesAutoresizingMaskIntoConstraints = false
        menuForPost.isHidden = false
        view.addSubview(menuForPost)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            menuForPost.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            menuForPost.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
            menuForPost.heightAnchor.constraint(equalToConstant: 300)
        ])
    }

    func updateLikes() {
        guard let likes = presenter.likes else { return }
        if likes.contains(where: { $0.documentID! == presenter.mainUserID }) {
            self.likeButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            self.likeButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        }
        self.likesLabel.text = "\(likes.count)"

    }

    func updateCommentsState() {
        if !presenter.post.isCommentariesEnabled {
            guard let docID = presenter.user.documentID else { return }
            if docID != self.presenter.mainUserID {
                addCommentView.backgroundColor = .clear
                addCommentView.isHidden = true
            }
        }
    }

    func showError(descr: String) {
        let uialert = UIAlertController(title: descr, message: descr, preferredStyle: .alert)
        let action = UIAlertAction(title: .localized(string: "Отмена"), style: .cancel)
        uialert.addAction(action)
        navigationController?.present(uialert, animated: true)
    }

    func updateCommentsNumber() {
        commentsLabel.text = "\(presenter.post.commentaries)"
        tableViewTitle.text = .localized(string: "\(presenter.post.commentaries) Комментариев")
    }

    func showCommentVC(commentID: String?, state: CommentState) {
        let commentView = CommentViewController()
        guard let documentID = presenter.post.documentID else { return }
        let commentor = presenter.mainUserID
        switch self.presenter.userState {
        case .mainUser:
            let commentPresenter = CommentViewPresenter(view: commentView, image: presenter.avatarImage, user: self.presenter.mainUserID, documentID: documentID, commentor: commentor, state: state, userState: self.presenter.userState)
            commentView.presenter = commentPresenter
            commentPresenter.commentID = commentID
        case .notMainUser:
            guard let userID = presenter.user.documentID else { return }
            let commentPresenter = CommentViewPresenter(view: commentView, image: presenter.avatarImage, user: userID, documentID: documentID, commentor: commentor, state: state, userState: self.presenter.userState)
            commentView.presenter = commentPresenter
            commentPresenter.commentID = commentID
        }
        commentView.modalPresentationStyle = .pageSheet
        if let sheet = commentView.sheetPresentationController {
            let customHeight = UISheetPresentationController.Detent.custom(identifier: .init("customHeight")) { context in
                return 500
            }
            sheet.detents = [customHeight]
            sheet.largestUndimmedDetentIdentifier = .some(customHeight.identifier)
        }
        self.navigationController?.present(commentView, animated: true)
    }

    func updateCommentsTableView() {
        commentsLabel.text = "\(presenter.post.commentaries)"
        tableViewTitle.text = .localized(string: "\(presenter.post.commentaries) Комментариев")
        commentsTableView.reloadData()
    }

    func updateImageView(image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            postImageView.image = image
            postImageView.clipsToBounds = true
            postImageView.layer.cornerRadius = 10
            addSubviews()
            layout()
            tuneTableView()
            updateAvatarImage()
        }
    }

    func comments(forSection: Int) -> Comment? {
        guard let comments = presenter.comments?.keys else {
            return nil
        }
        return Array(comments)[forSection]
    }
}

//MARK: -TableView DataSource
extension DetailPostViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentsTableCell.identifier) as? CommentsTableCell else { return UIView() }
        guard let commentInSection = comments(forSection: section) else { return UITableViewCell() }
        cell.updateView(comment: commentInSection, mainUser: self.presenter.mainUserID)
        cell.buttonTappedHandler = { [weak self] in
            self?.presenter.showCommetVC(commentID: commentInSection.documentID, state: .answer)
        }
        cell.incrementLikes = { [weak self] comment in
            guard let commentID = comment.documentID else { return }
            self?.presenter.incrementLikesForComment(commentID: commentID)
        }

        cell.decrementLikes = { [weak self] comment in
            guard let commentID = comment.documentID else { return }
            self?.presenter.decrementLikesForComment(commentID: commentID)
        }
        
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let number = presenter.comments?.count else { return 0 }
        return number
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let commentInSection = comments(forSection: section) else { return 0 }
        if let answerInSection = presenter.comments?[commentInSection] {
            guard let answersCount = answerInSection?.count else { return  0 }
            return answersCount
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AnswersTableCell.identifier, for: indexPath) as? AnswersTableCell else { return UITableViewCell()  }

        guard let comment = comments(forSection: indexPath.section) else { return UITableViewCell() }
        if let answers = presenter.comments?[comment] {
            guard let answer = answers?[indexPath.row] else { return UITableViewCell() }
            let commentor = answer.commentor
            FireStoreService.shared.getUser(id: commentor) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let user):
                    cell.backgroundColor = .systemBackground
                    cell.updateAnswers(answer: answer, user: user, date: answer.date, mainUser: self.presenter.mainUserID)
                    cell.buttonTappedHandler = { [weak self] in
                        self?.presenter.showCommetVC(commentID: comment.documentID, state: .answer)
                    }
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
            cell.buttonTappedHandler = { [weak self] in
                self?.presenter.showCommetVC(commentID: comment.documentID, state: .answer)
            }

            cell.incrementLikes = { [weak self] answer in
                guard let answerID = answer.documentID, let commentID = comment.documentID else { return }
                self?.presenter.incrementLikesForAnswer(answerID: answerID, commentID: commentID)
            }

            cell.decrementLikes = { [weak self] answer in
                guard let answerID = answer.documentID, let commentID = comment.documentID else { return }
                self?.presenter.decrementLikesForAnswer(answerID: answerID, commentID: commentID)
            }
        }
        return cell
    }
}

//MARK: -TableView Delegate
extension DetailPostViewController: UITableViewDelegate {

}

// MARK: -Layout

extension DetailPostViewController {

    func addSubviews() {
        menuForPost.isHidden = true
        view.addSubview(commentsTableView)
        detailPostView.addSubview(topSeparatorView)
        detailPostView.addSubview(avatarImageView)
        detailPostView.addSubview(identifierLabel)
        detailPostView.addSubview(jobLabel)
        detailPostView.addSubview(postImageView)
        detailPostView.addSubview(postTextLabel)
        detailPostView.addSubview(likeButton)
        detailPostView.addSubview(likesLabel)
        detailPostView.addSubview(commentsButton)
        detailPostView.addSubview(commentsLabel)
        detailPostView.addSubview(bookmarkButton)
        detailPostView.addSubview(separatorView)
        detailPostView.addSubview(tableViewTitle)
        view.addSubview(addCommentView)
        addCommentView.addSubview(addCommentImage)
        addCommentView.addSubview(addCommentLabel)
    }

    func layout() {

        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([

            commentsTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            commentsTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            commentsTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            commentsTableView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            commentsTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),

            addCommentView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 660),
            addCommentView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            addCommentView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            addCommentView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),

            addCommentImage.topAnchor.constraint(equalTo: addCommentView.topAnchor, constant: 14),
            addCommentImage.leadingAnchor.constraint(equalTo: addCommentView.leadingAnchor, constant: 16),
            addCommentImage.heightAnchor.constraint(equalToConstant: 15),
            addCommentImage.widthAnchor.constraint(equalToConstant: 15),

            addCommentLabel.topAnchor.constraint(equalTo: addCommentView.topAnchor, constant: 10),
            addCommentLabel.leadingAnchor.constraint(equalTo: addCommentImage.trailingAnchor, constant: 10),
            addCommentLabel.trailingAnchor.constraint(equalTo: addCommentView.trailingAnchor, constant: -190),
            addCommentLabel.bottomAnchor.constraint(equalTo: addCommentView.bottomAnchor, constant: -14)
        ])

        NSLayoutConstraint.activate([

            topSeparatorView.topAnchor.constraint(equalTo: detailPostView.topAnchor),
            topSeparatorView.leadingAnchor.constraint(equalTo: detailPostView.leadingAnchor, constant: 29),
            topSeparatorView.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -29),
            topSeparatorView.heightAnchor.constraint(equalToConstant: 1),

            avatarImageView.topAnchor.constraint(equalTo: topSeparatorView.bottomAnchor, constant: 18),
            avatarImageView.leadingAnchor.constraint(equalTo: detailPostView.leadingAnchor, constant: 29),
            avatarImageView.heightAnchor.constraint(equalToConstant: 30),
            avatarImageView.widthAnchor.constraint(equalToConstant: 30),

            identifierLabel.topAnchor.constraint(equalTo: detailPostView.topAnchor, constant: 18),
            identifierLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            identifierLabel.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -210),
            identifierLabel.heightAnchor.constraint(equalToConstant: 15),

            jobLabel.topAnchor.constraint(equalTo: identifierLabel.bottomAnchor, constant: 2),
            jobLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            jobLabel.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -210),
            jobLabel.heightAnchor.constraint(equalToConstant: 15),

            postImageView.topAnchor.constraint(equalTo: jobLabel.bottomAnchor, constant: 12),
            postImageView.leadingAnchor.constraint(equalTo: detailPostView.leadingAnchor, constant: 16),
            postImageView.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -16),
            postImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 212),

            postTextLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 5),
            postTextLabel.leadingAnchor.constraint(equalTo: detailPostView.leadingAnchor, constant: 20),
            postTextLabel.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -20),
            postTextLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 320),

            likeButton.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: 16),
            likeButton.leadingAnchor.constraint(equalTo: detailPostView.leadingAnchor, constant: 17),
            likeButton.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -395),
            likeButton.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -5),

            likesLabel.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: 16),
            likesLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 5),
            likesLabel.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -340),
            likesLabel.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -5),

            commentsButton.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: 16),
            commentsButton.leadingAnchor.constraint(equalTo: likesLabel.trailingAnchor, constant: 24),
            commentsButton.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -284),
            commentsButton.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -5),

            commentsLabel.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: 16),
            commentsLabel.leadingAnchor.constraint(equalTo: commentsButton.trailingAnchor, constant: 5),
            commentsLabel.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -241),
            commentsLabel.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -5),

            bookmarkButton.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: 16),
            bookmarkButton.leadingAnchor.constraint(equalTo: commentsLabel.trailingAnchor, constant: 183),
            bookmarkButton.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -30),
            bookmarkButton.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -5),

            separatorView.topAnchor.constraint(equalTo: bookmarkButton.bottomAnchor, constant: 17),
            separatorView.leadingAnchor.constraint(equalTo: detailPostView.leadingAnchor, constant: 29),
            separatorView.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -29),
            separatorView.heightAnchor.constraint(equalToConstant: 1),

            tableViewTitle.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 15),
            tableViewTitle.leadingAnchor.constraint(equalTo: detailPostView.leadingAnchor, constant: 16),
            tableViewTitle.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -200),
            tableViewTitle.bottomAnchor.constraint(equalTo: detailPostView.bottomAnchor, constant: -8)
        ])
    }

    func addSubviewsWithoutImage() {
        menuForPost.isHidden = true
        view.addSubview(commentsTableView)
        detailPostView.addSubview(topSeparatorView)
        detailPostView.addSubview(avatarImageView)
        detailPostView.addSubview(identifierLabel)
        detailPostView.addSubview(jobLabel)
        detailPostView.addSubview(postTextLabel)
        detailPostView.addSubview(likeButton)
        detailPostView.addSubview(likesLabel)
        detailPostView.addSubview(commentsButton)
        detailPostView.addSubview(commentsLabel)
        detailPostView.addSubview(bookmarkButton)
        detailPostView.addSubview(separatorView)
        detailPostView.addSubview(tableViewTitle)
        view.addSubview(addCommentView)
        addCommentView.addSubview(addCommentImage)
        addCommentView.addSubview(addCommentLabel)
    }

    func layoutSubviewsWithoutImage() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([

            commentsTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            commentsTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            commentsTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            commentsTableView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            commentsTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),

            addCommentView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 670),
            addCommentView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            addCommentView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            addCommentView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),

            addCommentImage.topAnchor.constraint(equalTo: addCommentView.topAnchor, constant: 25),
            addCommentImage.leadingAnchor.constraint(equalTo: addCommentView.leadingAnchor, constant: 16),
            addCommentImage.heightAnchor.constraint(equalToConstant: 15),
            addCommentImage.widthAnchor.constraint(equalToConstant: 15),

            addCommentLabel.centerYAnchor.constraint(equalTo: addCommentImage.centerYAnchor),
            addCommentLabel.leadingAnchor.constraint(equalTo: addCommentImage.trailingAnchor, constant: 10),
            addCommentLabel.trailingAnchor.constraint(equalTo: addCommentView.trailingAnchor, constant: -190),
            addCommentLabel.heightAnchor.constraint(equalToConstant: 50)
        ])

        NSLayoutConstraint.activate([

            topSeparatorView.topAnchor.constraint(equalTo: detailPostView.topAnchor),
            topSeparatorView.leadingAnchor.constraint(equalTo: detailPostView.leadingAnchor, constant: 29),
            topSeparatorView.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -29),
            topSeparatorView.heightAnchor.constraint(equalToConstant: 1),

            avatarImageView.topAnchor.constraint(equalTo: topSeparatorView.bottomAnchor, constant: 18),
            avatarImageView.leadingAnchor.constraint(equalTo: detailPostView.leadingAnchor, constant: 29),
            avatarImageView.heightAnchor.constraint(equalToConstant: 30),
            avatarImageView.widthAnchor.constraint(equalToConstant: 30),

            identifierLabel.topAnchor.constraint(equalTo: detailPostView.topAnchor, constant: 18),
            identifierLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            identifierLabel.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -210),


            jobLabel.topAnchor.constraint(equalTo: identifierLabel.bottomAnchor, constant: 2),
            jobLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            jobLabel.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -210),

            postTextLabel.topAnchor.constraint(equalTo: jobLabel.bottomAnchor, constant: 15),
            postTextLabel.leadingAnchor.constraint(equalTo: detailPostView.leadingAnchor, constant: 20),
            postTextLabel.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -20),
            postTextLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 320),

            likeButton.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: 16),
            likeButton.leadingAnchor.constraint(equalTo: detailPostView.leadingAnchor, constant: 17),
            likeButton.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -380),
            likeButton.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -5),

            likesLabel.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: 16),
            likesLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 5),
            likesLabel.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -337),
            likesLabel.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -5),

            commentsButton.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: 16),
            commentsButton.leadingAnchor.constraint(equalTo: likesLabel.trailingAnchor, constant: 24),
            commentsButton.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -294),
            commentsButton.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -5),

            commentsLabel.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: 16),
            commentsLabel.leadingAnchor.constraint(equalTo: commentsButton.trailingAnchor, constant: 5),
            commentsLabel.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -251),
            commentsLabel.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -5),

            bookmarkButton.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: 16),
            bookmarkButton.leadingAnchor.constraint(equalTo: commentsLabel.trailingAnchor, constant: 193),
            bookmarkButton.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -30),
            bookmarkButton.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -5),

            separatorView.topAnchor.constraint(equalTo: bookmarkButton.bottomAnchor, constant: 17),
            separatorView.leadingAnchor.constraint(equalTo: detailPostView.leadingAnchor, constant: 29),
            separatorView.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -29),
            separatorView.heightAnchor.constraint(equalToConstant: 1),

            tableViewTitle.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 15),
            tableViewTitle.leadingAnchor.constraint(equalTo: detailPostView.leadingAnchor, constant: 16),
            tableViewTitle.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -200),
            tableViewTitle.bottomAnchor.constraint(equalTo: detailPostView.bottomAnchor, constant: -8)
        ])
    }
}
