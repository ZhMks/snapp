//
//  ProfileViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 08.04.2024.
//

import UIKit

class ProfileViewController: UIViewController {
    // MARK: -Properties
    var presenter: ProfilePresenter!

    private var titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
    private var filteredArray: [EachPost] = []

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
        nameAndSurnameLabel.numberOfLines = 0
        nameAndSurnameLabel.textAlignment = .left
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
        detailInfo.addTarget(self, action: #selector(detailUserInformationTapped), for: .touchUpInside)
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
        editButton.addTarget(self, action: #selector(editProfileButtonTapped), for: .touchUpInside)
        return editButton
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
        numberOfSubscriptions.text = "\(presenter.mainUser.subscribtions.count)" + "\nПодписок"
        numberOfSubscriptions.textAlignment = .center
        numberOfSubscriptions.numberOfLines = 0
        numberOfSubscriptions.translatesAutoresizingMaskIntoConstraints = false
        return numberOfSubscriptions
    }()

    private lazy var numberOfSubscribers: UILabel = {
        let numberOfSubscribers = UILabel()
        numberOfSubscribers.font = UIFont(name: "Inter-Medium", size: 14)
        numberOfSubscribers.text = "\(presenter.mainUser.subscribers.count)" + "\nПодписчиков"
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
        createStorieButton.addTarget(self, action: #selector(createStorieButtonTapped), for: .touchUpInside)
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

    private lazy var addImageView: UIView = {
        let addImageView = UIView()
        addImageView.translatesAutoresizingMaskIntoConstraints = false
        return addImageView
    }()

    private lazy var addImageButton: UIButton = {
        let addImageButton = UIButton(type: .system)
        addImageButton.setBackgroundImage(UIImage(systemName: "photo"), for: .normal)
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        addImageButton.tintColor = ColorCreator.shared.createButtonColor()
        addImageButton.addTarget(self, action: #selector(addImageButtonTapped), for: .touchUpInside)
        return addImageButton
    }()

    private lazy var addImageLabel: UILabel = {
        let addImageLabel = UILabel()
        addImageLabel.text = .localized(string: "Фото")
        addImageLabel.textColor = ColorCreator.shared.createTextColor()
        addImageLabel.font = UIFont(name: "Inter-Light", size: 14)
        addImageLabel.translatesAutoresizingMaskIntoConstraints = false
        addImageLabel.textAlignment = .center
        return addImageLabel
    }()

    private lazy var photogalleryLabel: UILabel = {
        let photogalleryLabel = UILabel()
        photogalleryLabel.translatesAutoresizingMaskIntoConstraints = false
        let text: String = .localized(string: "Фотографии") + " \(presenter.photoAlbum?.count ?? 0)"
        photogalleryLabel.text = text
        photogalleryLabel.font = UIFont(name: "Inter-Medium", size: 16)
        photogalleryLabel.textColor = ColorCreator.shared.createTextColor()
        return photogalleryLabel
    }()

    private lazy var photogalleryButton: UIButton = {
        let photogalleryButton = UIButton(type: .system)
        photogalleryButton.translatesAutoresizingMaskIntoConstraints = false
        photogalleryButton.setBackgroundImage(UIImage(systemName: "chevron.right"), for: .normal)
        photogalleryButton.tintColor = ColorCreator.shared.createButtonColor()
        photogalleryButton.addTarget(self, action: #selector(goToPhotoalbumScreen), for: .touchUpInside)
        return photogalleryButton
    }()

    private lazy var photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let photoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        photoCollectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier)
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        return photoCollectionView
    }()

    private lazy var viewForTableTitle: UIView = {
        let viewForTableTitle = UIView()
        viewForTableTitle.translatesAutoresizingMaskIntoConstraints = false
        viewForTableTitle.backgroundColor = ColorCreator.shared.createPostBackgroundColor()
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

    private lazy var searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.delegate = self
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.layer.cornerRadius = 8.0
        searchTextField.backgroundColor = .systemBackground
        return searchTextField
    }()


    // MARK: -Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.addListenerForPost()
        presenter.addListenerForUser()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    //    addGestureToView()
        tuneNavItem()
        addSubviews()
        layout()
        tuneTableView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.removePostListener()
        presenter.removeUserListener()
    }

    // MARK: -Funcs
    @objc func createPostButtonTapped() {
        let createPostVC = CreatePostViewController()
        guard let userImage = presenter.avatarImage else { return }
        let createPostPresenter = CreatePostPresenter(view: createPostVC, mainUser: presenter.mainUser, userID: presenter.mainUserID, image: userImage, posts: presenter.posts)
        createPostVC.presenter = createPostPresenter
        createPostVC.modalPresentationStyle = .formSheet
        navigationController?.present(createPostVC, animated: true)
    }

    @objc func showSettingsVC() {
        let settingsVC = MainSettingsViewController()
        let settingsPresenter = MainSettingsPresenter(view: settingsVC, user: presenter.mainUser)
        settingsVC.presenter = settingsPresenter
        settingsVC.delegate = self
        let settingsNavigationController = UINavigationController(rootViewController: settingsVC)
        settingsNavigationController.modalPresentationStyle = .overFullScreen
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeIn)
        view.window!.layer.add(transition, forKey: kCATransition)
        navigationController?.present(settingsNavigationController, animated: true)
    }

    @objc func createStorieButtonTapped() {
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }
    }

    @objc func addImageButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
    }

    @objc func goToPhotoalbumScreen() {
        let photoAlbumVC = PhotoalbumViewController()
        let photoAlbumPresenter = PhotoalbumPresenter(view: photoAlbumVC, mainUserID: presenter.mainUserID)
        photoAlbumVC.presenter = photoAlbumPresenter
        navigationController?.pushViewController(photoAlbumVC, animated: true)
    }

    @objc func editProfileButtonTapped() {
        let profileChangeController = ProfileChangeViewController()
        let profileChangePresenter = ProfileChangePresenter(view: profileChangeController,
                                                            user: presenter.mainUser,
                                                            mainUserID: self.presenter.mainUserID)
        profileChangeController.presenter = profileChangePresenter
        profileChangeController.modalPresentationStyle = .overFullScreen
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        navigationController?.present(profileChangeController, animated: true)
    }

    @objc func detailUserInformationTapped() {
        let detailUserInfoVC = DetailUserInformationViewController()
        let detailUserInfoPresenter = DetailUserInformationPresenter(view: detailUserInfoVC, mainUser: self.presenter.mainUser, mainUserID: self.presenter.mainUserID)
        detailUserInfoVC.presenter = detailUserInfoPresenter
        detailUserInfoVC.modalPresentationStyle = .formSheet

        if let sheet = detailUserInfoVC.sheetPresentationController {
            sheet.detents = [.large()]
        }

        self.navigationController?.present(detailUserInfoVC, animated: true)
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

    @objc func removeSearchTextField() {
       searchTextField.removeFromSuperview()
    }

    private func addGestureToView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeSearchTextField))
        tapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(tapGesture)
    }
}

// MARK: -Output Presenter
extension ProfileViewController: ProfileViewProtocol {

    func updateTextData(user: FirebaseUser) {
        jobLabel.text = user.job
        nameAndSurnameLabel.text = "\(user.name)" + " \(user.surname)"
        titleLabel.text = user.identifier
    }

    func updateSubscriptions() {
        numberOfSubscriptions.text = .localizePlurals(key: "Subscriptions", number: presenter.mainUser.subscribtions.count)
    }

    func updateSubsribers() {
        numberOfSubscriptions.text = .localizePlurals(key: "Subsciptions", number: presenter.mainUser.subscribers.count)
    }

    func updateAlbum() {
        guard let number = presenter.photoAlbum?.count else {
            photogalleryLabel.text = .localizePlurals(key: "Photo", number: 0)
            photoCollectionView.reloadData()
            return
        }
        photogalleryLabel.text = .localizePlurals(key: "Photo", number: number)
        photoCollectionView.reloadData()
    }

    func updateData(data: [EachPost]) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            numberOfPosts.text = .localizePlurals(key: "Posts", number: presenter.posts.count)
            postsTableView.reloadData()
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
        DispatchQueue.main.async { [weak self] in
            let uialert = UIAlertController(title: error, message: error, preferredStyle: .alert)
            let action = UIAlertAction(title: .localized(string: "Отмена"), style: .cancel)
            uialert.addAction(action)
            self?.navigationController?.present(uialert, animated: true)
        }
    }
}


// MARK: -TableView DataSource

extension ProfileViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !filteredArray.isEmpty {
            return filteredArray.count
        }
        return  presenter.posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableCell.identifier, for: indexPath) as? PostTableCell else { return UITableViewCell() }

        let data = presenter.posts[indexPath.row]
        guard let docID = data.documentID else { return UITableViewCell() }

        if !filteredArray.isEmpty {
            let data = filteredArray[indexPath.row]
            cell.updateView(post: data, user: presenter.mainUser, state: .profileState, mainUserID: self.presenter.mainUserID)
        } else {
            cell.updateView(post: data, user: presenter.mainUser, state: .profileState, mainUserID: self.presenter.mainUserID)
        }

        cell.manuButtonTappedHandler = { [weak self] in
            guard let index = self?.presenter.posts.firstIndex(where: { $0.documentID == docID }) else { return }
            self?.presenter.posts.remove(at: index)
            self?.presenter.posts.insert(data, at: 0)
            self?.presenter.pinPost(docID: docID)
            self?.postsTableView.reloadData()
        }

        cell.incrementLikes = { [weak self, weak tableView]  (post, user) in
            self?.presenter.incrementLikes(post: post, user: user)
            self?.presenter.addToFavourites(post: post, user: user)
            tableView?.reloadRows(at: [indexPath], with: .automatic)
        }

        cell.decrementLikes = { [weak self, weak tableView] (post, user) in
            self?.presenter.decrementLikes(post: post, user: user)
            self?.presenter.removeFromFavourites(post: post, user: user)
            tableView?.reloadRows(at: [indexPath], with: .automatic)
        }

        cell.bookmarkButtonTapHandler = { [weak self] (post, user) in
            self?.presenter.addPostToBookMarks(post: post, user: user)
        }
        return cell
    }
}


// MARK: -TableView Delegate

extension ProfileViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let uiVIew = UIView(frame: CGRect(x: 0, y: 0, width: postsTableView.frame.size.width, height: 10))
        return uiVIew
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let image = self.presenter.avatarImage  else { return }
        let data = self.presenter.posts[indexPath.row]
        let detailPostVC = DetailPostViewController()
        let detailPostPresenter = DetailPostPresenter(view: detailPostVC,
                                                      user: self.presenter.mainUser, mainUserID: self.presenter.mainUserID,
                                                      post: data,
                                                      avatarImage: image,
                                                      userState: .mainUser)
        detailPostVC.presenter = detailPostPresenter
        detailPostVC.postMenuState = .detailPost
        self.navigationController?.pushViewController(detailPostVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

// MARK: -CollectionView DataSource
extension ProfileViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let number = presenter.photoAlbum else { return 0 }
        return number.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.identifier, for: indexPath) as? ProfileCollectionViewCell else { return UICollectionViewCell() }
        guard let photoAlbum = presenter.photoAlbum else { return UICollectionViewCell() }
        let data = photoAlbum[indexPath.row]
        cell.updateView(image: data)
        return cell
    }

}

// MARK: -CollectionView Delegate
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 72, height: 68)
    }
}

// MARK: -ImagePicker Controller
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let image = info[.originalImage] as? UIImage else { return }

        switch picker.sourceType {
        case .camera:
            presenter.saveImageIntoPhotoAlbum(image: image, state: .storieImage)
        case .photoLibrary:
            presenter.saveImageIntoPhotoAlbum(image: image, state: .photoImage)
        default: return
        }
        self.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextField Delegate
extension ProfileViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        filterArrayWithText(text: textField.text!)
        textField.text = ""
      //  searchTextField.removeFromSuperview()
        searchButton.isHidden = false
    }
}

// MARK: - SwitchControllersDelegate
extension ProfileViewController: SwitchViewControllerDelegate {
    func switchToFavourites() {
        self.tabBarController?.selectedIndex = 3
    }
}

// MARK: -Layout
extension ProfileViewController {

    func tuneNavItem() {
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(showSettingsVC))
        settingsButton.tintColor = .systemOrange
        self.navigationItem.rightBarButtonItem = settingsButton

        let textView = UIView(frame: CGRect(x: 0, y: 0, width: 240, height: 30))
        titleLabel.text = presenter.mainUser.identifier
        titleLabel.font = UIFont(name: "Inter-Medium", size: 14)
        textView.addSubview(titleLabel)
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
        mainContentView.addSubview(addImageView)
        addImageView.addSubview(addImageButton)
        addImageView.addSubview(addImageLabel)
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
            nameAndSurnameLabel.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -70),
            nameAndSurnameLabel.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -440),

            jobLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 15),
            jobLabel.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 60),
            jobLabel.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -110),
            jobLabel.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -410),

            detailInfo.centerYAnchor.constraint(equalTo:signalImage.centerYAnchor),
            detailInfo.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 124),
            detailInfo.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -90),
            detailInfo.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -380),

            signalImage.centerYAnchor.constraint(equalTo: detailInfo.centerYAnchor),
            signalImage.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 96),
            signalImage.widthAnchor.constraint(equalToConstant: 20),
            signalImage.heightAnchor.constraint(equalToConstant: 20),

            editButton.topAnchor.constraint(equalTo: signalImage.bottomAnchor, constant: 10),
            editButton.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            editButton.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            editButton.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -314),

            numberOfPosts.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 20),
            numberOfPosts.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 5),
            numberOfPosts.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -250),
            numberOfPosts.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -254),

            numberOfSubscriptions.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 20),
            numberOfSubscriptions.leadingAnchor.constraint(equalTo: numberOfPosts.trailingAnchor, constant: 10),
            numberOfSubscriptions.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -150),
            numberOfSubscriptions.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -254),

            numberOfSubscribers.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 20),
            numberOfSubscribers.leadingAnchor.constraint(equalTo: numberOfSubscriptions.trailingAnchor, constant: 20),
            numberOfSubscribers.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -10),
            numberOfSubscribers.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -254),

            separatorView.topAnchor.constraint(equalTo: numberOfPosts.bottomAnchor, constant: 4),
            separatorView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -249),

            createPostView.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 262),
            createPostView.centerXAnchor.constraint(equalTo: numberOfPosts.centerXAnchor),
            createPostView.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -150),

            createPostButton.topAnchor.constraint(equalTo: createPostView.topAnchor, constant: 25),
            createPostButton.leadingAnchor.constraint(equalTo: createPostView.leadingAnchor, constant: 20),
            createPostButton.trailingAnchor.constraint(equalTo: createPostView.trailingAnchor, constant: -20),
            createPostButton.bottomAnchor.constraint(equalTo: createPostView.bottomAnchor, constant: -25),

            createPostLabel.topAnchor.constraint(equalTo: createPostButton.bottomAnchor, constant: 4),
            createPostLabel.leadingAnchor.constraint(equalTo: createPostView.leadingAnchor),
            createPostLabel.trailingAnchor.constraint(equalTo: createPostView.trailingAnchor),
            createPostLabel.bottomAnchor.constraint(equalTo: createPostView.bottomAnchor),

            createStorieView.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 262),
            createStorieView.centerXAnchor.constraint(equalTo: numberOfSubscriptions.centerXAnchor),
            createStorieView.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -150),

            createStorieButton.topAnchor.constraint(equalTo: createStorieView.topAnchor, constant: 25),
            createStorieButton.leadingAnchor.constraint(equalTo: createStorieView.leadingAnchor, constant: 20),
            createStorieButton.trailingAnchor.constraint(equalTo: createStorieView.trailingAnchor, constant: -20),
            createStorieButton.bottomAnchor.constraint(equalTo: createStorieView.bottomAnchor, constant: -25),

            createStorieLabel.topAnchor.constraint(equalTo: createStorieButton.bottomAnchor, constant: 4),
            createStorieLabel.leadingAnchor.constraint(equalTo: createStorieView.leadingAnchor),
            createStorieLabel.trailingAnchor.constraint(equalTo: createStorieView.trailingAnchor),
            createStorieLabel.bottomAnchor.constraint(equalTo: createStorieView.bottomAnchor),

            addImageView.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 262),
            addImageView.centerXAnchor.constraint(equalTo: numberOfSubscribers.centerXAnchor),
            addImageView.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -150),

            addImageButton.topAnchor.constraint(equalTo: addImageView.topAnchor, constant: 25),
            addImageButton.leadingAnchor.constraint(equalTo: addImageView.leadingAnchor, constant: 20),
            addImageButton.trailingAnchor.constraint(equalTo: addImageView.trailingAnchor, constant: -20),
            addImageButton.bottomAnchor.constraint(equalTo: addImageView.bottomAnchor, constant: -25),

            addImageLabel.topAnchor.constraint(equalTo: addImageButton.bottomAnchor, constant: 5),
            addImageLabel.leadingAnchor.constraint(equalTo: addImageView.leadingAnchor),
            addImageLabel.trailingAnchor.constraint(equalTo: addImageView.trailingAnchor),
            addImageLabel.bottomAnchor.constraint(equalTo: addImageView.bottomAnchor),

            photogalleryLabel.topAnchor.constraint(equalTo: createPostView.bottomAnchor, constant: 22),
            photogalleryLabel.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            photogalleryLabel.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor, constant: -216),
            photogalleryLabel.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -100),

            photogalleryButton.centerYAnchor.constraint(equalTo: photogalleryLabel.centerYAnchor),
            photogalleryButton.leadingAnchor.constraint(equalTo: photogalleryLabel.trailingAnchor, constant: 170),
            photogalleryButton.widthAnchor.constraint(equalToConstant: 24),
            photogalleryButton.heightAnchor.constraint(equalToConstant: 24),

            photoCollectionView.topAnchor.constraint(equalTo: photogalleryLabel.bottomAnchor, constant: 12),
            photoCollectionView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 16),
            photoCollectionView.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -25),

            viewForTableTitle.topAnchor.constraint(equalTo: photoCollectionView.bottomAnchor, constant: 10),
            viewForTableTitle.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor),
            viewForTableTitle.trailingAnchor.constraint(equalTo: mainContentView.trailingAnchor),
            viewForTableTitle.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),

            tableViewTitle.topAnchor.constraint(equalTo: viewForTableTitle.topAnchor, constant: 5),
            tableViewTitle.leadingAnchor.constraint(equalTo: viewForTableTitle.leadingAnchor, constant: 16),
            tableViewTitle.trailingAnchor.constraint(equalTo: viewForTableTitle.trailingAnchor, constant: -265),
            tableViewTitle.bottomAnchor.constraint(equalTo: viewForTableTitle.bottomAnchor, constant: -5),

            searchButton.centerYAnchor.constraint(equalTo: tableViewTitle.centerYAnchor),
            searchButton.heightAnchor.constraint(equalToConstant: 25),
            searchButton.widthAnchor.constraint(equalToConstant: 25),
            searchButton.trailingAnchor.constraint(equalTo: viewForTableTitle.trailingAnchor, constant: -15)
        ])

        signalImage.layer.cornerRadius = signalImage.frame.size.width / 2
    }

    func tuneTableView() {
        postsTableView.rowHeight = UITableView.automaticDimension
        postsTableView.estimatedRowHeight = 44.0
        postsTableView.tableFooterView = UIView()
        postsTableView.setAndLayout(header: mainContentView)
        postsTableView.separatorStyle = .none
    }

}

