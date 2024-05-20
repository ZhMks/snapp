//
//  DetailPostViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 14.05.2024.
//

import UIKit
import FirebaseAuth

class DetailPostViewController: UIViewController {

    // MARK: -PROPERTIES
    var presenter: DetailPostPresenter!

    private lazy var detailPostView: UIView = {
        let detailPostView = UIView()
        detailPostView.translatesAutoresizingMaskIntoConstraints = false
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
        avatarImageView.image = presenter.image
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
        likeButton.tintColor = ColorCreator.shared.createButtonColor()
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
        tableViewTitle.text = .localized(string: "\(presenter.post.commentaries)")
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
        addCommentView.backgroundColor = .systemGray5
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
        addCommentLabel.text = .localized(string: "оставить комментарий")
        return addCommentLabel
    }()

    // MARK: -LIFECYCLE

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(commentAdded), name: Notification.Name("commentAdded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(commentAdded), name: Notification.Name("answerAdded"), object: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        layout()
        tuneNavItem()
        tuneTableView()
        view.backgroundColor = .systemBackground
        updateAvatarImage()
        presenter.fetchComments()
    }

    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: -FUNCS

    func tuneNavItem() {
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

    @objc func showSettingsVC() {

    }

    @objc func dismissViewController() {
        self.navigationController?.popViewController(animated: true)
    }

    func tuneTableView() {
        commentsTableView.register(CommentsTableCell.self, forCellReuseIdentifier: CommentsTableCell.identifier)
        commentsTableView.rowHeight = UITableView.automaticDimension
        commentsTableView.estimatedRowHeight = 44.0
        commentsTableView.setAndLayout(header: detailPostView)
        commentsTableView.tableFooterView = UIView()
        commentsTableView.separatorStyle = .none
        self.commentsTableView.reloadData()
    }

    func updateAvatarImage() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
    }

    @objc func addCommentTapped() {
        let commentView = CommentViewController()
         guard let documentID = presenter.post.documentID else { return }
         guard let commentor = Auth.auth().currentUser?.uid else { return }
         let commentPresenter = CommentViewPresenter(view: commentView, image: presenter.image, user: commentor, documentID: documentID, commentor: commentor, firestoreService: presenter.firestoreService)
         commentView.presenter = commentPresenter
         commentView.modalPresentationStyle = .formSheet
         present(commentView, animated: true)
    }

    @objc func commentAdded() {
        presenter.fetchComments()
    }

    @objc func answerAdded() {
        presenter.fetchComments()
    }
}


// MARK: -OUTPUTPRESENTER
extension DetailPostViewController: DetailPostViewProtocol {


    func showCommentVC(with: String, commentID: String?) {
        let commentView = CommentViewController()
         guard let documentID = presenter.post.documentID else { return }
         guard let commentor = Auth.auth().currentUser?.uid else { return }
        let commentPresenter = CommentViewPresenter(view: commentView, image: presenter.image, user: with, documentID: documentID, commentor: commentor, firestoreService: presenter.firestoreService)
         commentView.presenter = commentPresenter
         commentPresenter.commentID = commentID
         commentView.modalPresentationStyle = .formSheet
         present(commentView, animated: true)
    }

    
    
    func updateCommentsTableView() {
        commentsTableView.reloadData()
    }
    
    func showError() {
        print()
    }
    
    func updateImageView(image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            postImageView.image = image
            postImageView.clipsToBounds = true
            postImageView.layer.cornerRadius = 10
        }
    }

    func comments(forSection: Int) -> Comment? {
        guard let comments = presenter.comments?.keys else {
            return nil
        }
        return Array(comments)[forSection]
    }
}

//MARK: -TABLEVIEWDATATSOURCE
extension DetailPostViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentsTableCell.identifier) as? CommentsTableCell else { return UIView() }
        guard let commentInSection = comments(forSection: section) else { return UITableViewCell() }
        cell.updateView(comment: commentInSection, firestoreService: presenter.firestoreService)
        cell.buttonTappedHandler = { [weak self] in
            self?.presenter.showCommetVC(with: commentInSection.commentor, commentID: commentInSection.documentID)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentsTableCell.identifier, for: indexPath) as? CommentsTableCell else { return UITableViewCell()  }
        
        guard let comment = comments(forSection: indexPath.section) else { return UITableViewCell() }
        cell.buttonTappedHandler = { [weak self] in
            print("SMT")
            self?.presenter.showCommetVC(with: comment.commentor, commentID: comment.documentID)
        }
        if let answers = presenter.comments?[comment] {
            guard let answer = answers?[indexPath.row] else { return UITableViewCell() }
            let commentor = answer.commentor
            cell.buttonTappedHandler = { [weak self] in
                print("SMT")
                self?.presenter.showCommetVC(with: commentor, commentID: comment.documentID)
            }
            presenter.firestoreService.getUser(id: commentor) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let user):
                    cell.backgroundColor = .systemBackground
                    cell.updateAnswers(answer: answer, user: user, date: answer.date, firestoreService: presenter.firestoreService)
                    guard let commentor = user.documentID else { return }
                    cell.buttonTappedHandler = { [weak self] in
                        print("SMT")
                        self?.presenter.showCommetVC(with: commentor, commentID: comment.documentID)
                    }
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
        return cell
    }


}


//MARK: -TABLEVIEWDELEGATE
extension DetailPostViewController: UITableViewDelegate {

}

// MARK: -LAYOUT

extension DetailPostViewController {
    func addSubviews() {
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

            addCommentView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 630),
            addCommentView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            addCommentView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            addCommentView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),

            addCommentImage.topAnchor.constraint(equalTo: addCommentView.topAnchor, constant: 14),
            addCommentImage.leadingAnchor.constraint(equalTo: addCommentView.leadingAnchor, constant: 16),
            addCommentImage.heightAnchor.constraint(equalToConstant: 15),
            addCommentImage.widthAnchor.constraint(equalToConstant: 15),

            addCommentLabel.centerYAnchor.constraint(equalTo: addCommentImage.centerYAnchor),
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

            identifierLabel.topAnchor.constraint(equalTo: topSeparatorView.bottomAnchor, constant: 18),
            identifierLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            identifierLabel.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -210),
            identifierLabel.bottomAnchor.constraint(equalTo: detailPostView.bottomAnchor, constant: -680),

            jobLabel.topAnchor.constraint(equalTo: identifierLabel.bottomAnchor, constant: 2),
            jobLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            jobLabel.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -210),
            jobLabel.bottomAnchor.constraint(equalTo: detailPostView.bottomAnchor, constant: -670),

            postImageView.topAnchor.constraint(equalTo: jobLabel.bottomAnchor, constant: 12),
            postImageView.leadingAnchor.constraint(equalTo: detailPostView.leadingAnchor, constant: 16),
            postImageView.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -16),
            postImageView.bottomAnchor.constraint(equalTo: detailPostView.bottomAnchor, constant: -424),

            postTextLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 5),
            postTextLabel.leadingAnchor.constraint(equalTo: detailPostView.leadingAnchor, constant: 16),
            postTextLabel.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -16),
            postTextLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 340),

            likeButton.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: 16),
            likeButton.leadingAnchor.constraint(equalTo: detailPostView.leadingAnchor, constant: 17),
            likeButton.heightAnchor.constraint(equalToConstant: 22),
            likeButton.widthAnchor.constraint(equalToConstant: 22),

            likesLabel.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: 16),
            likesLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 5),
            likesLabel.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -307),
            likesLabel.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -5),

            commentsButton.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: 16),
            commentsButton.leadingAnchor.constraint(equalTo: likesLabel.trailingAnchor, constant: 24),
            commentsButton.heightAnchor.constraint(equalToConstant: 22),
            commentsButton.widthAnchor.constraint(equalToConstant: 22),
            commentsButton.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -5),

            commentsLabel.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: 16),
            commentsLabel.leadingAnchor.constraint(equalTo: commentsButton.trailingAnchor, constant: 5),
            commentsLabel.trailingAnchor.constraint(equalTo: detailPostView.trailingAnchor, constant: -231),
            commentsLabel.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -5),

            bookmarkButton.topAnchor.constraint(equalTo: postTextLabel.bottomAnchor, constant: 16),
            bookmarkButton.leadingAnchor.constraint(equalTo: commentsLabel.trailingAnchor, constant: 183),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 22),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 22),
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