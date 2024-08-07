//
//  DetailUserViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 22.04.2024.
//

import UIKit

class DetailUserViewController: UIViewController {

    //MARK: -Properties

    var presenter: DetailPresenter!
    private var filteredArray: [EachPost] = []

    private lazy var topSeparatorView: UIView = {
        let topSeparatorView = UIView()
        topSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        topSeparatorView.backgroundColor = .systemGray2
        return topSeparatorView
    }()

    private lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.clipsToBounds = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        return avatarImageView
    }()

    private lazy var nameAndSurnameLabel: UILabel = {
        let nameAndSurnameLabel = UILabel()
        nameAndSurnameLabel.font = UIFont(name: "Inter-Medium", size: 18)
        nameAndSurnameLabel.textColor = ColorCreator.shared.createTextColor()
        nameAndSurnameLabel.text = "\(presenter.user.name) " + "  \(presenter.user.surname)"
        nameAndSurnameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameAndSurnameLabel.numberOfLines = 0
        return nameAndSurnameLabel
    }()

    private lazy var jobLabel: UILabel = {
        let jobLabel = UILabel()
        jobLabel.font = UIFont(name: "Inter-Medium", size: 12)
        jobLabel.textColor = .systemGray2
        jobLabel.text = "\(presenter.user.job)"
        jobLabel.translatesAutoresizingMaskIntoConstraints = false
        return jobLabel
    }()

    private lazy var detailInfo: UIButton = {
        let detailInfo = UIButton(type: .system)
        detailInfo.translatesAutoresizingMaskIntoConstraints = false
        detailInfo.setTitle(.localized(string: "Подробная информация"), for: .normal)
        detailInfo.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        detailInfo.titleLabel?.font = UIFont(name: "Inter-Medium", size: 14)
        return detailInfo
    }()

    private lazy var signalImage: UIImageView = {
        let signalImage = UIImageView(image: UIImage(systemName: "exclamationmark.circle.fill"))
        signalImage.translatesAutoresizingMaskIntoConstraints = false
        signalImage.tintColor = .systemOrange
        signalImage.clipsToBounds = true
        signalImage.layer.cornerRadius = signalImage.frame.size.width / 2
        return signalImage
    }()

    private lazy var subscribeButton: UIButton = {
        let subscribeButton = UIButton(type: .system)
        subscribeButton.translatesAutoresizingMaskIntoConstraints = false
        subscribeButton.titleLabel?.font = UIFont(name: "Inter-Medium", size: 16)
        subscribeButton.setTitleColor(.white, for: .normal)
        subscribeButton.setTitle(.localized(string: "Подписаться"), for: .normal)
        subscribeButton.backgroundColor = ColorCreator.shared.createButtonColor()
        subscribeButton.layer.cornerRadius = 10.0
        subscribeButton.addTarget(self, action: #selector(addToSubscribers), for: .touchUpInside)
        return subscribeButton
    }()

    private lazy var sendMessageButton: UIButton = {
        let sendMessageButton = UIButton(type: .system)
        sendMessageButton.translatesAutoresizingMaskIntoConstraints = false
        sendMessageButton.titleLabel?.font = UIFont(name: "Inter-Medium", size: 16)
        sendMessageButton.setTitleColor(.white, for: .normal)
        sendMessageButton.setTitle(.localized(string: "Сообщение"), for: .normal)
        sendMessageButton.backgroundColor = .systemGray2
        sendMessageButton.isEnabled = false
        sendMessageButton.layer.cornerRadius = 10.0
        return sendMessageButton
    }()

    private lazy var numberOfPosts: UILabel = {
        let numberOfPosts = UILabel()
        numberOfPosts.font = UIFont(name: "Inter-Medium", size: 14)
        numberOfPosts.text = "\(presenter.posts.count)" + "\nПубликаций"
        numberOfPosts.textAlignment = .center
        numberOfPosts.numberOfLines = 0
        numberOfPosts.translatesAutoresizingMaskIntoConstraints = false
        numberOfPosts.textColor = .systemOrange
        return numberOfPosts
    }()

    private lazy var numberOfSubscriptions: UILabel = {
        let numberOfSubscriptions = UILabel()
        numberOfSubscriptions.font = UIFont(name: "Inter-Medium", size: 14)
        numberOfSubscriptions.text = "\(presenter.user.subscribtions.count)" + "\nПодписок"
        numberOfSubscriptions.textAlignment = .center
        numberOfSubscriptions.numberOfLines = 0
        numberOfSubscriptions.translatesAutoresizingMaskIntoConstraints = false
        return numberOfSubscriptions
    }()

    private lazy var numberOfSubscribers: UILabel = {
        let numberOfSubscribers = UILabel()
        numberOfSubscribers.font = UIFont(name: "Inter-Medium", size: 14)
        numberOfSubscribers.text = "\(presenter.user.subscribers.count)" + "\nПодписчиков"
        numberOfSubscribers.textAlignment = .center
        numberOfSubscribers.numberOfLines = 0
        numberOfSubscribers.translatesAutoresizingMaskIntoConstraints = false
        return numberOfSubscribers
    }()

    private lazy var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .systemGray2
        return separatorView
    }()

    private lazy var photogalleryLabel: UILabel = {
        let photogalleryLabel = UILabel()
        photogalleryLabel.translatesAutoresizingMaskIntoConstraints = false
        photogalleryLabel.text = .localized(string: "Фотографии" + "  \(presenter.user.photoAlbum.count)")
        photogalleryLabel.font = UIFont(name: "Inter-Medium", size: 16)
        photogalleryLabel.textColor = ColorCreator.shared.createTextColor()
        return photogalleryLabel
    }()

    private lazy var photogalleryButton: UIButton = {
        let photogalleryButton = UIButton(type: .system)
        photogalleryButton.translatesAutoresizingMaskIntoConstraints = false
        photogalleryButton.setBackgroundImage(UIImage(systemName: "chevron.right"), for: .normal)
        photogalleryButton.tintColor = ColorCreator.shared.createButtonColor()
        photogalleryButton.addTarget(self, action: #selector(tapOnPhotogalleryButton), for: .touchUpInside)
        return photogalleryButton
    }()

    private lazy var photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        let photoScrollView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        photoScrollView.translatesAutoresizingMaskIntoConstraints = false
        photoScrollView.delegate = self
        photoScrollView.dataSource = self
        photoScrollView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier)
        return photoScrollView
    }()

    private lazy var viewForTableTitle: UIView = {
        let viewForTableTitle = UIView()
        viewForTableTitle.translatesAutoresizingMaskIntoConstraints = false
        viewForTableTitle.backgroundColor = .systemGray5
        return viewForTableTitle
    }()

    private lazy var tableViewTitle: UILabel = {
        let tableViewTitle = UILabel()
        tableViewTitle.translatesAutoresizingMaskIntoConstraints = false
        tableViewTitle.text = .localized(string: "Записи \(presenter.user.name)")
        tableViewTitle.font = UIFont(name: "Inter-Medium", size: 16)
        tableViewTitle.textColor = .systemOrange
        return tableViewTitle
    }()

    private lazy var searchButton: UIButton = {
        let searchButton = UIButton(type: .system)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.setBackgroundImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = ColorCreator.shared.createButtonColor()
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        return searchButton
    }()

    private lazy var mainContentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()

    private lazy var postsTableView: UITableView = {
        let postsTableView = UITableView()
        postsTableView.register(PostTableCell.self, forCellReuseIdentifier: PostTableCell.identifier)
        postsTableView.translatesAutoresizingMaskIntoConstraints = false
        postsTableView.delegate = self
        postsTableView.dataSource = self
        return postsTableView
    }()

    private lazy var middleSeparatorView: UIView = {
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .systemGray2
        return separatorView
    }()

    private lazy var searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.delegate = self
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.layer.cornerRadius = 8.0
        searchTextField.backgroundColor = .systemBackground
        return searchTextField
    }()


    // MARK: -Lifecycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.addObserverForuser()
        presenter.addObserverForPost()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tuneTableView()
        tuneNavItem()
        addSubviews()
        layout()
        tuneTableView()
        presenter.fetchPhotoAlbum()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.removeObserverForUser()
        presenter.removeObserverForPosts()
    }

    // MARK: -Funcs

    @objc func addToSubscribers() {
        if presenter.user.subscribers.contains(presenter.mainUserID) {
            presenter.removeSubscribtion()
            presenter.checkSubscribers()
        } else {
            presenter.addSubscriber()
            presenter.registerNotifications()
            presenter.checkSubscribers()
        }
    }

    @objc func dismissViewController() {
        navigationController?.popViewController(animated: true)
    }

    @objc func removeSearchTextField() {
        searchTextField.removeFromSuperview()
    }

    func addGestureRecognizerToView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeSearchTextField))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
    }

    @objc func searchButtonTapped() {
        filteredArray = []

        postsTableView.reloadData()

        viewForTableTitle.addSubview(searchTextField)
        searchButton.isHidden = true

        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: viewForTableTitle.topAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: viewForTableTitle.trailingAnchor, constant: -10),
            searchTextField.bottomAnchor.constraint(equalToSystemSpacingBelow: viewForTableTitle.bottomAnchor, multiplier: -5),
            searchTextField.widthAnchor.constraint(equalToConstant: 180)
        ])

        searchTextField.becomeFirstResponder()
    }

    private func filterArrayWithText(text: String) {
        guard let text = searchTextField.text else { return }
        self.filteredArray = self.presenter.posts.filter { $0.text.lowercased().contains(text.lowercased()) }
        postsTableView.reloadData()
    }

    @objc func tapOnPhotogalleryButton() {
        guard let userID = presenter.user.documentID else { return }
        let photoAlbumVC = PhotoalbumViewController()
        let photoAlbumPresenter = PhotoalbumPresenter(view: photoAlbumVC, mainUserID: userID)
        photoAlbumVC.presenter = photoAlbumPresenter
        navigationController?.pushViewController(photoAlbumVC, animated: true)
    }
}

// MARK: -Presenter Output
extension DetailUserViewController: DetailViewProtocol {
   
    func updateSubButton() {
        if presenter.user.subscribers.contains(presenter.mainUserID) {
            subscribeButton.setTitle(.localized(string: "Отписаться"), for: .normal)
        } else {
            subscribeButton.setTitle(.localized(string: "Подписаться"), for: .normal)
        }
    }

    func showFeedMenu(post: EachPost) {
        let menuForFeedVC = MenuForFeedViewController()
        let presenter = MenuForFeedPresenter(view: menuForFeedVC, user: self.presenter.user, post: post, mainUserID: self.presenter.mainUserID)
        menuForFeedVC.modalPresentationStyle = .formSheet

        if let sheet = menuForFeedVC.sheetPresentationController {
            let customHeight = UISheetPresentationController.Detent.custom(identifier: .init("customHeight")) { context in
                return 300
            }
            sheet.detents = [customHeight]
            sheet.largestUndimmedDetentIdentifier = .some(customHeight.identifier)
        }
        menuForFeedVC.presenter = presenter
        self.navigationController?.present(menuForFeedVC, animated: true)
    }
    
    func updateAlbum() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            photoCollectionView.reloadData()
        }
    }

    func updateData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            postsTableView.reloadData()
        }
    }

    func updateAvatarImage(image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.avatarImageView.image = image
            self.avatarImageView.clipsToBounds = true
            self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2
        }
    }

    func showErrorAler(error: String) {
        let alertController = UIAlertController(title: error, message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: .localized(string: "Отмена"), style: .cancel)
        alertController.addAction(action)
        navigationController?.present(alertController, animated: true)
    }
}


// MARK: -TableView DataSource

extension DetailUserViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !filteredArray.isEmpty {
            return filteredArray.count
        }
        return  presenter.posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableCell.identifier, for: indexPath) as? PostTableCell else { return UITableViewCell() }
        let data = presenter.posts[indexPath.row]
        let mainUserID = self.presenter.mainUserID

        if !filteredArray.isEmpty {
            let data = filteredArray[indexPath.row]
            cell.updateView(post: data, user: presenter.user, state: .feedState, mainUserID: mainUserID)
        } else {
            cell.updateView(post: data, user: presenter.user, state: .feedState, mainUserID: mainUserID)
        }

        cell.showMenuForFeed = { [weak self] post in
            self?.presenter.showFeedMenu(post: post)
        }

        cell.incrementLikes = { [weak self, weak tableView] (post, user) in
            self?.presenter.incrementLikes(post: post, user: user)
            self?.presenter.saveIntoFavourites(post: post, user: user)
            tableView?.reloadRows(at: [indexPath], with: .fade)
        }

        cell.decrementLikes = { [weak self, weak tableView] (post, user) in
            self?.presenter.decrementLikes(post: post, user: user)
            self?.presenter.removeFromFavourites(post: post, user: user)
            tableView?.reloadRows(at: [indexPath], with: .fade)
        }

        cell.bookmarkButtonTapHandler = { [weak self] (post, user) in
            self?.presenter.addToBookmarks(post: post, user: user)
        }

        return cell
    }

}


// MARK: -TableView Delegate

extension DetailUserViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = presenter.posts[indexPath.row]
        let detailPostVC = DetailPostViewController()
        guard let image = presenter.avatarImage  else { return }
        if data.image!.isEmpty {
            let detailPostPresenter = DetailPostPresenter(view: detailPostVC,
                                                          user: presenter.user,
                                                          mainUserID: self.presenter.mainUserID,
                                                          post: data,
                                                          avatarImage: image,
                                                          userState: .notMainUser)
            detailPostVC.presenter = detailPostPresenter
            detailPostVC.postMenuState = .feedPost
            self.navigationController?.pushViewController(detailPostVC, animated: true)
        } else {
            let detailPostPresenter = DetailPostPresenter(view: detailPostVC,
                                                          user: presenter.user,
                                                          mainUserID: self.presenter.mainUserID,
                                                          post: data,
                                                          avatarImage: image,
                                                          userState: .notMainUser)
            detailPostVC.presenter = detailPostPresenter
            detailPostVC.postMenuState = .feedPost
            self.navigationController?.pushViewController(detailPostVC, animated: true)
        }
    }

}

// MARK: -UICollectionView DataSource
extension DetailUserViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let number = presenter.photoAlbum?.count else { return 0 }
        return number
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.identifier, for: indexPath) as? ProfileCollectionViewCell else { return UICollectionViewCell() }
        guard let data = presenter.photoAlbum?[indexPath.row] else { return UICollectionViewCell() }
        cell.updateView(image: data)
        return cell
    }

}

// MARK: -UICollectionView Delegate
extension DetailUserViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 72, height: 68)
    }
}

// MARK: - UITextFieldDelegate
extension DetailUserViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        filterArrayWithText(text: textField.text!)
        textField.text = ""
        searchTextField.removeFromSuperview()
        searchButton.isHidden = false
    }
}

// MARK: -Layout
extension DetailUserViewController {
    func tuneNavItem() {

        let leftArrowButton = UIButton(type: .system)
        leftArrowButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        leftArrowButton.tintColor = .systemOrange
        leftArrowButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftArrowButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)

        let textView = UIView(frame: CGRect(x: 0, y: 0, width: 350, height: 30))
        let title = UILabel(frame: CGRect(x: 40, y: 0, width: 250, height: 30))
        title.text = .localized(string: "\(presenter.user.name)" + " \(presenter.user.surname)")
        title.font = UIFont(name: "Inter-Medium", size: 14)
        textView.addSubview(title)
        textView.addSubview(leftArrowButton)
        let leftButton = UIBarButtonItem(customView: textView)
        self.navigationItem.leftBarButtonItem = leftButton
    }

    func addSubviews() {
        view.addSubview(postsTableView)

        mainContentView.addSubview(topSeparatorView)
        mainContentView.addSubview(middleSeparatorView)
        mainContentView.addSubview(avatarImageView)
        mainContentView.addSubview(nameAndSurnameLabel)
        mainContentView.addSubview(jobLabel)
        mainContentView.addSubview(detailInfo)
        mainContentView.addSubview(signalImage)
        mainContentView.addSubview(subscribeButton)
        mainContentView.addSubview(sendMessageButton)
        mainContentView.addSubview(numberOfPosts)
        mainContentView.addSubview(numberOfSubscriptions)
        mainContentView.addSubview(numberOfSubscribers)
        mainContentView.addSubview(separatorView)
        mainContentView.addSubview(photogalleryLabel)
        mainContentView.addSubview(photogalleryButton)
        mainContentView.addSubview(photoCollectionView)
        mainContentView.addSubview(viewForTableTitle)
        viewForTableTitle.addSubview(tableViewTitle)
        viewForTableTitle.addSubview(searchButton)
    }


    func layout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            postsTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            postsTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            postsTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            postsTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            postsTableView.widthAnchor.constraint(equalTo: safeArea.widthAnchor)
        ])

        NSLayoutConstraint.activate([

            topSeparatorView.topAnchor.constraint(equalTo: mainContentView.topAnchor),
            topSeparatorView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            topSeparatorView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            topSeparatorView.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),

            avatarImageView.topAnchor.constraint(equalTo: topSeparatorView.bottomAnchor, constant: 15),
            avatarImageView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 24),
            avatarImageView.heightAnchor.constraint(equalToConstant: 69),
            avatarImageView.widthAnchor.constraint(equalToConstant: 69),

            nameAndSurnameLabel.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 20),
            nameAndSurnameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 15),
            nameAndSurnameLabel.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -110),
            nameAndSurnameLabel.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -440),

            jobLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 15),
            jobLabel.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 60),
            jobLabel.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -110),
            jobLabel.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -410),

            detailInfo.topAnchor.constraint(equalTo: jobLabel.bottomAnchor, constant: 5),
            detailInfo.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 124),
            detailInfo.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -90),
            detailInfo.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -380),

            signalImage.topAnchor.constraint(equalTo: jobLabel.bottomAnchor, constant: 5),
            signalImage.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 96),
            signalImage.heightAnchor.constraint(equalToConstant: 20),
            signalImage.widthAnchor.constraint(equalToConstant: 20),

            subscribeButton.topAnchor.constraint(equalTo: signalImage.bottomAnchor, constant: 10),
            subscribeButton.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            subscribeButton.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -185),
            subscribeButton.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -330),

            sendMessageButton.topAnchor.constraint(equalTo: signalImage.bottomAnchor, constant: 10),
            sendMessageButton.leadingAnchor.constraint(equalTo: subscribeButton.trailingAnchor, constant: 16),
            sendMessageButton.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            sendMessageButton.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -330),

            middleSeparatorView.topAnchor.constraint(equalTo: sendMessageButton.bottomAnchor, constant: 15),
            middleSeparatorView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            middleSeparatorView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            middleSeparatorView.heightAnchor.constraint(equalToConstant: 1),

            numberOfPosts.topAnchor.constraint(equalTo: middleSeparatorView.bottomAnchor, constant: 5),
            numberOfPosts.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 5),
            numberOfPosts.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -240),
            numberOfPosts.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -254),

            numberOfSubscriptions.topAnchor.constraint(equalTo: subscribeButton.bottomAnchor, constant: 20),
            numberOfSubscriptions.leadingAnchor.constraint(equalTo: numberOfPosts.trailingAnchor, constant: 10),
            numberOfSubscriptions.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -140),
            numberOfSubscriptions.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -254),

            numberOfSubscribers.topAnchor.constraint(equalTo: subscribeButton.bottomAnchor, constant: 20),
            numberOfSubscribers.leadingAnchor.constraint(equalTo: numberOfSubscriptions.trailingAnchor, constant: 20),
            numberOfSubscribers.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -10),
            numberOfSubscribers.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -254),

            separatorView.topAnchor.constraint(equalTo: numberOfPosts.bottomAnchor, constant: 4),
            separatorView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -249),

            photogalleryLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 22),
            photogalleryLabel.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            photogalleryLabel.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -216),
            photogalleryLabel.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -210),

            photogalleryButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 25),
            photogalleryButton.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 345),
            photogalleryButton.heightAnchor.constraint(equalToConstant: 20),
            photogalleryButton.widthAnchor.constraint(equalToConstant: 20),

            photoCollectionView.topAnchor.constraint(equalTo: photogalleryLabel.bottomAnchor, constant: 12),
            photoCollectionView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            photoCollectionView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor),
            photoCollectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 110),

            viewForTableTitle.topAnchor.constraint(equalTo: photoCollectionView.bottomAnchor, constant: 10),
            viewForTableTitle.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor),
            viewForTableTitle.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor),
            viewForTableTitle.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),

            tableViewTitle.topAnchor.constraint(equalTo: viewForTableTitle.topAnchor, constant: 5),
            tableViewTitle.leadingAnchor.constraint(equalTo: viewForTableTitle.leadingAnchor, constant: 16),
            tableViewTitle.trailingAnchor.constraint(equalTo: viewForTableTitle.trailingAnchor, constant: -205),
            tableViewTitle.bottomAnchor.constraint(equalTo: viewForTableTitle.bottomAnchor, constant: -5),

            searchButton.centerYAnchor.constraint(equalTo: tableViewTitle.centerYAnchor),
            searchButton.heightAnchor.constraint(equalToConstant: 25),
            searchButton.widthAnchor.constraint(equalToConstant: 25),
            searchButton.trailingAnchor.constraint(equalTo: viewForTableTitle.trailingAnchor, constant: -15)
        ])
    }

   private func tuneTableView() {
        postsTableView.rowHeight = UITableView.automaticDimension
        postsTableView.estimatedRowHeight = 44.0
        postsTableView.tableFooterView = UIView()
        postsTableView.setAndLayout(header: mainContentView)
        postsTableView.separatorStyle = .none
        self.postsTableView.reloadData()
    }

}
