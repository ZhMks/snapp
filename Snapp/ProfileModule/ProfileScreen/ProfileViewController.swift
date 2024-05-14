//
//  ProfileViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 08.04.2024.
//

import UIKit

class ProfileViewController: UIViewController {
    // MARK: -PROPERTIES
    var presenter: ProfilePresenter!

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
        nameAndSurnameLabel.text = "\(presenter.mainUser.name) " + "  \(presenter.mainUser.surname)"
        nameAndSurnameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameAndSurnameLabel
    }()

    private lazy var jobLabel: UILabel = {
        let jobLabel = UILabel()
        jobLabel.font = UIFont(name: "Inter-Medium", size: 12)
        jobLabel.textColor = .systemGray2
        jobLabel.text = "\(presenter.mainUser.job)"
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
        return signalImage
    }()

    private lazy var editButton: UIButton = {
        let editButton = UIButton(type: .system)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.titleLabel?.font = UIFont(name: "Inter-Medium", size: 16)
        editButton.setTitleColor(.white, for: .normal)
        editButton.setTitle(.localized(string: "Редактировать"), for: .normal)
        editButton.backgroundColor = .systemOrange
        editButton.layer.cornerRadius = 10.0
        return editButton
    }()

    private lazy var numberOfPosts: UILabel = {
        let numberOfPosts = UILabel()
        numberOfPosts.font = UIFont(name: "Inter-Medium", size: 14)
        numberOfPosts.text = "1400\nПубликаций"
        numberOfPosts.textAlignment = .center
        numberOfPosts.numberOfLines = 0
        numberOfPosts.translatesAutoresizingMaskIntoConstraints = false
        numberOfPosts.textColor = .systemOrange
        return numberOfPosts
    }()

    private lazy var numberOfSubscriptions: UILabel = {
        let numberOfSubscriptions = UILabel()
        numberOfSubscriptions.font = UIFont(name: "Inter-Medium", size: 14)
        numberOfSubscriptions.text = "258\nПодписок"
        numberOfSubscriptions.textAlignment = .center
        numberOfSubscriptions.numberOfLines = 0
        numberOfSubscriptions.translatesAutoresizingMaskIntoConstraints = false
        return numberOfSubscriptions
    }()

    private lazy var numberOfSubscribers: UILabel = {
        let numberOfSubscribers = UILabel()
        numberOfSubscribers.font = UIFont(name: "Inter-Medium", size: 14)
        numberOfSubscribers.text = "650\nПодписчиков"
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

    private lazy var createPostView: UIView = {
        let createPostView = UIView()
        createPostView.translatesAutoresizingMaskIntoConstraints = false
        return createPostView
    }()

    private lazy var createPostButton: UIButton = {
        let createPostButton = UIButton(type: .system)
        createPostButton.setBackgroundImage(UIImage(named: "createPostButton"), for: .normal)
        createPostButton.translatesAutoresizingMaskIntoConstraints = false
        createPostButton.addTarget(self, action: #selector(createPostButtonTapped), for: .touchUpInside)
        createPostButton.clipsToBounds = true
        return createPostButton
    }()

    private lazy var createPostLabel: UILabel = {
        let createPostLabel = UILabel()
        createPostLabel.text = .localized(string: "Запись")
        createPostLabel.font = UIFont(name: "Inter-Light", size: 14)
        createPostLabel.textColor = ColorCreator.shared.createTextColor()
        createPostLabel.textAlignment = .center
        createPostLabel.translatesAutoresizingMaskIntoConstraints = false
        return createPostLabel
    }()

    private lazy var createStorieView: UIView = {
        let createStorieView = UIView()
        createStorieView.translatesAutoresizingMaskIntoConstraints = false
        return createStorieView
    }()

    private lazy var createStorieButton: UIButton = {
        let createStorieButton = UIButton(type: .system)
        createStorieButton.setBackgroundImage(UIImage(systemName: "camera"), for: .normal)
        createStorieButton.translatesAutoresizingMaskIntoConstraints = false
        createStorieButton.tintColor = ColorCreator.shared.createButtonColor()
        return createStorieButton
    }()

    private lazy var createStorieLabel: UILabel = {
        let createStorieLabel = UILabel()
        createStorieLabel.text = .localized(string: "История")
        createStorieLabel.textColor = ColorCreator.shared.createTextColor()
        createStorieLabel.font = UIFont(name: "Inter-Light", size: 14)
        createStorieLabel.textAlignment = .center
        createStorieLabel.translatesAutoresizingMaskIntoConstraints = false
        return createStorieLabel
    }()

    private lazy var addPhotoView: UIView = {
        let addPhotoView = UIView()
        addPhotoView.translatesAutoresizingMaskIntoConstraints = false
        return addPhotoView
    }()

    private lazy var addPhotoButton: UIButton = {
        let addPhotoButton = UIButton(type: .system)
        addPhotoButton.setBackgroundImage(UIImage(systemName: "photo"), for: .normal)
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        addPhotoButton.tintColor = ColorCreator.shared.createButtonColor()
        return addPhotoButton
    }()

    private lazy var addPhotoLabel: UILabel = {
        let addPhotoLabel = UILabel()
        addPhotoLabel.text = .localized(string: "Фото")
        addPhotoLabel.textColor = ColorCreator.shared.createTextColor()
        addPhotoLabel.font = UIFont(name: "Inter-Light", size: 14)
        addPhotoLabel.translatesAutoresizingMaskIntoConstraints = false
        addPhotoLabel.textAlignment = .center
        return addPhotoLabel
    }()

    private lazy var photogalleryLabel: UILabel = {
        let photogalleryLabel = UILabel()
        photogalleryLabel.translatesAutoresizingMaskIntoConstraints = false
        photogalleryLabel.text = .localized(string: "Фотографии" + "  \(presenter.mainUser.stories.count)")
        photogalleryLabel.font = UIFont(name: "Inter-Medium", size: 16)
        photogalleryLabel.textColor = ColorCreator.shared.createTextColor()
        return photogalleryLabel
    }()

    private lazy var photogalleryButton: UIButton = {
        let photogalleryButton = UIButton(type: .system)
        photogalleryButton.translatesAutoresizingMaskIntoConstraints = false
        photogalleryButton.setBackgroundImage(UIImage(systemName: "chevron.right"), for: .normal)
        photogalleryButton.tintColor = ColorCreator.shared.createButtonColor()
        return photogalleryButton
    }()

    private lazy var photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let photoScrollView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        photoScrollView.translatesAutoresizingMaskIntoConstraints = false
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
        tableViewTitle.text = .localized(string: "Мои записи")
        tableViewTitle.font = UIFont(name: "Inter-Medium", size: 16)
        tableViewTitle.textColor = .systemOrange
        return tableViewTitle
    }()

    private lazy var searchButton: UIButton = {
        let searchButton = UIButton(type: .system)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.setBackgroundImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = ColorCreator.shared.createButtonColor()
        return searchButton
    }()

    private lazy var mainContentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()

    private lazy var postsTableView: UITableView = {
        let postsTableView = UITableView()
        postsTableView.translatesAutoresizingMaskIntoConstraints = false
        postsTableView.delegate = self
        postsTableView.dataSource = self
        return postsTableView
    }()


    // MARK: -LIFECYCLE

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchPostsIfNeeded), name: Notification.Name("newPost"), object: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tuneNavItem()
        addSubviews()
        layout()
        tuneTableView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: -FUNCS
    @objc func createPostButtonTapped() {
        let createPostVC = CreatePostViewController()
        guard let userImage = presenter.image else { return }
        let createPostPresenter = CreatePostPresenter(view: createPostVC, mainUser: presenter.mainUser, userID: presenter.userID, firestoreService: presenter.firestoreService, image: userImage, posts: presenter.posts)
        createPostVC.presenter = createPostPresenter
        createPostVC.modalPresentationStyle = .formSheet
        navigationController?.present(createPostVC, animated: true)
    }

    @objc func showSettingsVC() {
        //        let settingsVC = SettingsViewController()
        //        let settingsPresenter = SettingPresenter(view: settingsVC, user: presenter.firebaseUser, firestoreService: presenter.firestoreService)
        //        settingsVC.presenter = settingsPresenter
        //        navigationController?.present(settingsVC, animated: true)
    }

    @objc func fetchPostsIfNeeded() {
        presenter.fetchPosts()
    }
}

// MARK: -OUTPUT PRESENTER
extension ProfileViewController: ProfileViewProtocol {

    func updateStorie(stories: [UIImage]?) {
        print()
    }
    
    func updateAlbum(photo: [UIImage]?) {
        print()
    }
    

    func updateData(data: [MainPost]) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.tuneTableView()
        }
    }
    

    func updateAvatarImage(image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.avatarImageView.image = image
            self.avatarImageView.clipsToBounds = true
            self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2
        }
    }

    func showErrorAler(error: String) {
        print("ThisISERRORALERTINPROFILE")
    }
}


// MARK: -TABLEVIEWDATASOURCE

extension ProfileViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.posts.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.posts[section].postsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableCell.identifier, for: indexPath) as? PostTableCell else { return UITableViewCell() }
        let data = presenter.posts[indexPath.section].postsArray[indexPath.row]
        let date = presenter.posts[indexPath.section].date
        cell.updateView(post: data, user: presenter.mainUser, date: date)
        return cell
    }
    

}


// MARK: -TABLEVIEWDELEGATE

extension ProfileViewController: UITableViewDelegate {

}

// MARK: -LAYOUT
extension ProfileViewController {
    func tuneNavItem() {
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(showSettingsVC))
        settingsButton.tintColor = .systemOrange
        self.navigationItem.rightBarButtonItem = settingsButton

        let textView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 30))
        title.text = presenter.mainUser.identifier
        title.font = UIFont(name: "Inter-Medium", size: 14)
        textView.addSubview(title)
        let leftButton = UIBarButtonItem(customView: textView)
        self.navigationItem.leftBarButtonItem = leftButton
    }

    func addSubviews() {
        view.addSubview(postsTableView)

        mainContentView.addSubview(avatarImageView)
        mainContentView.addSubview(nameAndSurnameLabel)
        mainContentView.addSubview(jobLabel)
        mainContentView.addSubview(detailInfo)
        mainContentView.addSubview(signalImage)
        mainContentView.addSubview(editButton)
        mainContentView.addSubview(numberOfPosts)
        mainContentView.addSubview(numberOfSubscriptions)
        mainContentView.addSubview(numberOfSubscribers)
        mainContentView.addSubview(separatorView)
        mainContentView.addSubview(createPostView)
        createPostView.addSubview(createPostButton)
        createPostView.addSubview(createPostLabel)
        mainContentView.addSubview(createStorieView)
        createStorieView.addSubview(createStorieButton)
        createStorieView.addSubview(createStorieLabel)
        mainContentView.addSubview(addPhotoView)
        addPhotoView.addSubview(addPhotoButton)
        addPhotoView.addSubview(addPhotoLabel)
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
            avatarImageView.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 25),
            avatarImageView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 24),
            avatarImageView.heightAnchor.constraint(equalToConstant: 69),
            avatarImageView.widthAnchor.constraint(equalToConstant: 69),
            avatarImageView.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -420),

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
            signalImage.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -380),
            signalImage.heightAnchor.constraint(equalToConstant: 20),
            signalImage.widthAnchor.constraint(equalToConstant: 20),

            editButton.topAnchor.constraint(equalTo: signalImage.bottomAnchor, constant: 10),
            editButton.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            editButton.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            editButton.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -314),

            numberOfPosts.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 20),
            numberOfPosts.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 5),
            numberOfPosts.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -240),
            numberOfPosts.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -254),

            numberOfSubscriptions.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 20),
            numberOfSubscriptions.leadingAnchor.constraint(equalTo: numberOfPosts.trailingAnchor, constant: 10),
            numberOfSubscriptions.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -140),
            numberOfSubscriptions.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -254),

            numberOfSubscribers.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 20),
            numberOfSubscribers.leadingAnchor.constraint(equalTo: numberOfSubscriptions.trailingAnchor, constant: 20),
            numberOfSubscribers.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -10),
            numberOfSubscribers.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -254),

            separatorView.topAnchor.constraint(equalTo: numberOfPosts.bottomAnchor, constant: 4),
            separatorView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -249),

            createPostView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 5),
            createPostView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 33),
            createPostView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -290),
            createPostView.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -150),

            createPostButton.topAnchor.constraint(equalTo: createPostView.topAnchor, constant: 25),
            createPostButton.leadingAnchor.constraint(equalTo: createPostView.leadingAnchor, constant: 20),
            createPostButton.trailingAnchor.constraint(equalTo: createPostView.trailingAnchor, constant: -20),
            createPostButton.bottomAnchor.constraint(equalTo: createPostView.bottomAnchor, constant: -25),

            createPostLabel.topAnchor.constraint(equalTo: createPostButton.bottomAnchor, constant: 4),
            createPostLabel.leadingAnchor.constraint(equalTo: createPostView.leadingAnchor),
            createPostLabel.trailingAnchor.constraint(equalTo: createPostView.trailingAnchor),
            createPostLabel.bottomAnchor.constraint(equalTo: createPostView.bottomAnchor),

            createStorieView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 5),
            createStorieView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 145),
            createStorieView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -160),
            createStorieView.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -150),

            createStorieButton.topAnchor.constraint(equalTo: createStorieView.topAnchor, constant: 25),
            createStorieButton.leadingAnchor.constraint(equalTo: createStorieView.leadingAnchor, constant: 20),
            createStorieButton.trailingAnchor.constraint(equalTo: createStorieView.trailingAnchor, constant: -20),
            createStorieButton.bottomAnchor.constraint(equalTo: createStorieView.bottomAnchor, constant: -25),

            createStorieLabel.topAnchor.constraint(equalTo: createStorieButton.bottomAnchor, constant: 4),
            createStorieLabel.leadingAnchor.constraint(equalTo: createStorieView.leadingAnchor),
            createStorieLabel.trailingAnchor.constraint(equalTo: createStorieView.trailingAnchor),
            createStorieLabel.bottomAnchor.constraint(equalTo: createStorieView.bottomAnchor),

            addPhotoView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 5),
            addPhotoView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 273),
            addPhotoView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -50),
            addPhotoView.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -150),

            addPhotoButton.topAnchor.constraint(equalTo: addPhotoView.topAnchor, constant: 25),
            addPhotoButton.leadingAnchor.constraint(equalTo: addPhotoView.leadingAnchor, constant: 20),
            addPhotoButton.trailingAnchor.constraint(equalTo: addPhotoView.trailingAnchor, constant: -20),
            addPhotoButton.bottomAnchor.constraint(equalTo: addPhotoView.bottomAnchor, constant: -25),

            addPhotoLabel.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 4),
            addPhotoLabel.leadingAnchor.constraint(equalTo: addPhotoView.leadingAnchor),
            addPhotoLabel.trailingAnchor.constraint(equalTo: addPhotoView.trailingAnchor),
            addPhotoLabel.bottomAnchor.constraint(equalTo: addPhotoView.bottomAnchor),

            photogalleryLabel.topAnchor.constraint(equalTo: createPostView.bottomAnchor, constant: 22),
            photogalleryLabel.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            photogalleryLabel.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -216),
            photogalleryLabel.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -100),

            photogalleryButton.topAnchor.constraint(equalTo: addPhotoView.bottomAnchor, constant: 25),
            photogalleryButton.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 345),
            photogalleryButton.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -20),
            photogalleryButton.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -100),

            photoCollectionView.topAnchor.constraint(equalTo: photogalleryLabel.bottomAnchor, constant: 12),
            photoCollectionView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            photoCollectionView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -25),

            viewForTableTitle.topAnchor.constraint(equalTo: photoCollectionView.bottomAnchor),
            viewForTableTitle.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor),
            viewForTableTitle.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor),
            viewForTableTitle.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor),

            tableViewTitle.topAnchor.constraint(equalTo: viewForTableTitle.topAnchor, constant: 5),
            tableViewTitle.leadingAnchor.constraint(equalTo: viewForTableTitle.leadingAnchor, constant: 16),
            tableViewTitle.trailingAnchor.constraint(equalTo: viewForTableTitle.trailingAnchor, constant: -265),
            tableViewTitle.bottomAnchor.constraint(equalTo: viewForTableTitle.bottomAnchor, constant: -5),

            searchButton.topAnchor.constraint(equalTo: viewForTableTitle.topAnchor, constant: 5),
            searchButton.leadingAnchor.constraint(equalTo: viewForTableTitle.leadingAnchor, constant: 360),
            searchButton.trailingAnchor.constraint(equalTo: viewForTableTitle.trailingAnchor, constant: -8),
            searchButton.bottomAnchor.constraint(equalTo: viewForTableTitle.bottomAnchor, constant: -5)
        ])

        signalImage.layer.cornerRadius = signalImage.frame.size.width / 2
    }

    func tuneTableView() {
        postsTableView.register(PostTableCell.self, forCellReuseIdentifier: PostTableCell.identifier)
        postsTableView.rowHeight = UITableView.automaticDimension
        postsTableView.estimatedRowHeight = 44.0
        postsTableView.tableHeaderView = mainContentView
        postsTableView.tableFooterView = UIView()
        postsTableView.setAndLayout(header: mainContentView)
        postsTableView.separatorStyle = .none
        self.postsTableView.reloadData()
    }

}
