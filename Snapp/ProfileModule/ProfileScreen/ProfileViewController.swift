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
        avatarImageView.contentMode = .scaleAspectFit
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

    private lazy var photoScrollView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let photoScrollView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        photoScrollView.translatesAutoresizingMaskIntoConstraints = false
        photoScrollView.backgroundColor = .systemRed
        return photoScrollView
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

    private lazy var mainScrollView: UIScrollView = {
        let mainScrollView = UIScrollView()
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        mainScrollView.showsVerticalScrollIndicator = true
        return mainScrollView
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
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tuneNavItem()
        addSubviews()
        tuneTableView()
        layout()
        presenter.fetchPosts()
        print("Posts in profile: \(presenter.posts.count)")
    }

    // MARK: -FUNCS
    @objc func createPostButtonTapped() {
        let text = "TestPostText"
        let image = UIImage(named: "postimage")
        presenter.createPost(text: text, image: image!) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let postMainModel):
                print(postMainModel!.forEach({ print($0.date) }))
                DispatchQueue.main.async {
                    self.postsTableView.reloadData()
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    @objc func showSettingsVC() {
        //        let settingsVC = SettingsViewController()
        //        let settingsPresenter = SettingPresenter(view: settingsVC, user: presenter.firebaseUser, firestoreService: presenter.firestoreService)
        //        settingsVC.presenter = settingsPresenter
        //        navigationController?.present(settingsVC, animated: true)
    }

}

// MARK: -OUTPUT PRESENTER
extension ProfileViewController: ProfileViewProtocol {

    func updateAvatarImage(image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.avatarImageView.image = image
            avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
        }
    }

    func showErrorAler(error: String) {
        print("ThisISERRORALERTINPROFILE")
    }
}


// MARK: -TABLEVIEWDATASOURCE

extension ProfileViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 120))
        guard let headerCell = tableView.dequeueReusableCell(withIdentifier: HeaderTableCell.identifier) as? HeaderTableCell else { return UIView() }
        guard let image = self.presenter.image else { return UIView() }
        headerCell.updateView(user: presenter.mainUser, image: image)
            headerCell.frame = headerView.bounds
            headerView.addSubview(headerCell)
            return headerView
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.posts.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.posts[section].postsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableCell.identifier, for: indexPath) as? PostTableCell else { return UITableViewCell() }
        let data = presenter.posts[indexPath.section].postsArray[indexPath.row]
        cell.updateView(post: data)
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
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(postsTableView)
        mainContentView.addSubview(avatarImageView)
        mainContentView.addSubview(nameAndSurnameLabel)
        mainContentView.addSubview(jobLabel)
        mainContentView.addSubview(signalImage)
        mainContentView.addSubview(detailInfo)
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
        mainContentView.addSubview(photoScrollView)
        mainContentView.addSubview(tableViewTitle)
        mainContentView.addSubview(searchButton)
    }

    func layout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),

            postsTableView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            postsTableView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            postsTableView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            postsTableView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
            postsTableView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor),
            postsTableView.heightAnchor.constraint(equalTo: mainScrollView.heightAnchor),

            avatarImageView.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 14),
            avatarImageView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 26),
            avatarImageView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -290),
            avatarImageView.bottomAnchor.constraint(equalTo: editButton.topAnchor),

            nameAndSurnameLabel.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 22),
            nameAndSurnameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
            nameAndSurnameLabel.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -83),
            nameAndSurnameLabel.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -660),

            jobLabel.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 47),
            jobLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 15),
            jobLabel.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -91),
            jobLabel.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -640),

            signalImage.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 83),
            signalImage.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 110),
            signalImage.heightAnchor.constraint(equalToConstant: 20),
            signalImage.widthAnchor.constraint(equalToConstant: 20),

            detailInfo.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 67),
            detailInfo.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 124),
            detailInfo.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -76),
            detailInfo.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -600),

            editButton.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 120),
            editButton.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            editButton.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            editButton.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -540),

            numberOfPosts.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 174),
            numberOfPosts.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            numberOfPosts.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -256),
            numberOfPosts.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -460),

            numberOfSubscriptions.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 174),
            numberOfSubscriptions.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 142),
            numberOfSubscriptions.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -146),
            numberOfSubscriptions.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -460),

            numberOfSubscribers.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 174),
            numberOfSubscribers.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 252),
            numberOfSubscribers.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            numberOfSubscribers.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -460),

            separatorView.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 260),
            separatorView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -460),

            createPostView.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 270),
            createPostView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 26),
            createPostView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -298),
            createPostView.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -370),

            createPostButton.topAnchor.constraint(equalTo: createPostView.topAnchor, constant: 20),
            createPostButton.leadingAnchor.constraint(equalTo: createPostView.leadingAnchor, constant: 20),
            createPostButton.trailingAnchor.constraint(equalTo: createPostView.trailingAnchor, constant: -20),
            createPostButton.bottomAnchor.constraint(equalTo: createPostView.bottomAnchor, constant: -30),

            createPostLabel.topAnchor.constraint(equalTo: createPostView.topAnchor, constant: 55),
            createPostLabel.leadingAnchor.constraint(equalTo: createPostView.leadingAnchor),
            createPostLabel.trailingAnchor.constraint(equalTo: createPostView.trailingAnchor),
            createPostLabel.bottomAnchor.constraint(equalTo: createPostView.bottomAnchor),

            createStorieView.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 270),
            createStorieView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 155),
            createStorieView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -161),
            createStorieView.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -370),

            createStorieButton.topAnchor.constraint(equalTo: createStorieView.topAnchor, constant: 15),
            createStorieButton.leadingAnchor.constraint(equalTo: createStorieView.leadingAnchor, constant: 15),
            createStorieButton.trailingAnchor.constraint(equalTo: createStorieView.trailingAnchor, constant: -15),
            createStorieButton.bottomAnchor.constraint(equalTo: createStorieView.bottomAnchor, constant: -30),

            createStorieLabel.topAnchor.constraint(equalTo: createStorieView.topAnchor, constant: 55),
            createStorieLabel.leadingAnchor.constraint(equalTo: createStorieView.leadingAnchor),
            createStorieLabel.trailingAnchor.constraint(equalTo: createStorieView.trailingAnchor),
            createStorieLabel.bottomAnchor.constraint(equalTo: createStorieView.bottomAnchor),

            addPhotoView.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 270),
            addPhotoView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 285),
            addPhotoView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -40),
            addPhotoView.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -370),

            addPhotoButton.topAnchor.constraint(equalTo: addPhotoView.topAnchor, constant: 20),
            addPhotoButton.leadingAnchor.constraint(equalTo: addPhotoView.leadingAnchor, constant: 20),
            addPhotoButton.trailingAnchor.constraint(equalTo: addPhotoView.trailingAnchor, constant: -20),
            addPhotoButton.bottomAnchor.constraint(equalTo: addPhotoView.bottomAnchor, constant: -30),

            addPhotoLabel.topAnchor.constraint(equalTo: addPhotoView.topAnchor, constant: 55),
            addPhotoLabel.leadingAnchor.constraint(equalTo: addPhotoView.leadingAnchor),
            addPhotoLabel.trailingAnchor.constraint(equalTo: addPhotoView.trailingAnchor),
            addPhotoLabel.bottomAnchor.constraint(equalTo: addPhotoView.bottomAnchor),

            photogalleryLabel.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 360),
            photogalleryLabel.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            photogalleryLabel.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -216),
            photogalleryLabel.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -330),

            photogalleryButton.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 365),
            photogalleryButton.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 336),
            photogalleryButton.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -25),
            photogalleryButton.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -335),

            photoScrollView.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 390),
            photoScrollView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            photoScrollView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor),
            photoScrollView.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -280),

            tableViewTitle.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 450),
            tableViewTitle.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            tableViewTitle.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -265),
            tableViewTitle.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -230),

            searchButton.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 460),
            searchButton.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 345),
            searchButton.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -25),
            searchButton.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -240),
        ])
    }

    func tuneTableView() {
        postsTableView.rowHeight = UITableView.automaticDimension
        postsTableView.estimatedRowHeight = 44.0
        postsTableView.setAndLayout(header: mainContentView)
        postsTableView.tableFooterView = UIView()
        postsTableView.register(PostTableCell.self, forCellReuseIdentifier: PostTableCell.identifier)
    }
}
