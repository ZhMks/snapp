//
//  PhotoalbumViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 20.05.2024.
//

import UIKit


class PhotoalbumViewController: UIViewController {

    // MARK: -Properties

    var presenter: PhotoalbumPresenter!
    private var selectedAlbumIndex: Int = 0

    private lazy var topSeparatorView: UIView = {
        let topSeparatorView = UIView()
        topSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        topSeparatorView.backgroundColor = .systemGray2
        return topSeparatorView
    }()

    private lazy var albumCollectionViewTitle: UILabel = {
        let albumCollectionViewTitle = UILabel()
        albumCollectionViewTitle.text = .localized(string: "Альбомы")
        albumCollectionViewTitle.textColor = ColorCreator.shared.createTextColor()
        albumCollectionViewTitle.translatesAutoresizingMaskIntoConstraints = false
        return albumCollectionViewTitle
    }()

    private lazy var albumCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let albumCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        albumCollectionView.translatesAutoresizingMaskIntoConstraints = false
        albumCollectionView.delegate = self
        albumCollectionView.dataSource = self
        albumCollectionView.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier )
        return albumCollectionView
    }()

    private lazy var showAllAlbumsButton: UIButton = {
        let showAllAlbumsButton = UIButton(type: .system)
        showAllAlbumsButton.translatesAutoresizingMaskIntoConstraints = false
        showAllAlbumsButton.setTitle(.localized(string: "Показать все"), for: .normal)
        showAllAlbumsButton.setTitleColor(.systemOrange, for: .normal)
        return showAllAlbumsButton
    }()

    private lazy var bottomSeparatorView: UIView = {
        let separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .systemGray2
        return separatorView
    }()


    private lazy var photoCollectionViewTitle: UILabel = {
        let photoCollectionViewTitle = UILabel()
        photoCollectionViewTitle.text = .localized(string: "Все фотографии")
        photoCollectionViewTitle.textColor = ColorCreator.shared.createTextColor()
        photoCollectionViewTitle.translatesAutoresizingMaskIntoConstraints = false
        return photoCollectionViewTitle
    }()

    private lazy var photoCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let photoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        photoCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        return photoCollectionView
    }()

    // MARK: -Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        layout()
        tuneNavItem()
        view.backgroundColor = .systemBackground
        presenter.fetchImageFromStorage()
    }

    // MARK: -Funcs

    func tuneNavItem() {
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(addImageToAlbum))
        settingsButton.tintColor = .systemOrange
        self.navigationItem.rightBarButtonItem = settingsButton

        let leftArrowButton = UIButton(type: .system)
        leftArrowButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        leftArrowButton.tintColor = .systemOrange
        leftArrowButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftArrowButton.addTarget(self, action: #selector(dismissController), for: .touchUpInside)

        let textView = UIView(frame: CGRect(x: 0, y: 0, width: 330, height: 30))
        let title = UILabel(frame: CGRect(x: 30, y: 0, width: 250, height: 30))
        title.text = .localized(string: "Фотографии")
        title.font = UIFont(name: "Inter-Medium", size: 14)
        textView.addSubview(title)
        textView.addSubview(leftArrowButton)
        let leftButton = UIBarButtonItem(customView: textView)
        self.navigationItem.leftBarButtonItem = leftButton
    }

    @objc func addImageToAlbum(image: UIImage) {
       let uiimagePicker = UIImagePickerController()
        uiimagePicker.delegate = self
        present(uiimagePicker, animated: true)
    }

    @objc func dismissController() {
        self.navigationController?.popViewController(animated: true)
    }
}


    // MARK: -Presenter Output
extension PhotoalbumViewController: PhotoalbumViewProtocol {
    func showError(error: String) {
        let alertController = UIAlertController(title: error, message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: .localized(string: "Отмена"), style: .cancel)
        alertController.addAction(action)
        navigationController?.present(alertController, animated: true)
    }
    
    func updateCollectionView() {
        albumCollectionView.reloadData()
        photoCollectionView.reloadData()
    }
}


//MARK: -UICollectionView Datasource
extension PhotoalbumViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.albumCollectionView {
            guard  let number = presenter.photoAlbum?.keys.count else {
                return 0
            }
            return number
        } else if collectionView == photoCollectionView {
            guard let photoAlbum = self.presenter.photoAlbum else { return 0 }
            if photoAlbum.isEmpty {
                return 0 
            }
            let selectedAlbum = Array(photoAlbum.keys)[selectedAlbumIndex]
            return photoAlbum[selectedAlbum]??.count ?? 0
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.albumCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell .identifier, for: indexPath) as? AlbumCollectionViewCell else { return UICollectionViewCell() }
            guard let photoAlbum = presenter.photoAlbum else { return UICollectionViewCell() }
            let imageKey = Array(photoAlbum.keys)[indexPath.row]
            guard let imageValue = photoAlbum[imageKey] else { return UICollectionViewCell() }
            guard let image = imageValue?.last else { return UICollectionViewCell() }
            cell.updateView(image: image)
            return cell
        }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
            guard let photoAlbum = presenter.photoAlbum else { return UICollectionViewCell() }
            let arraySet = Array(photoAlbum.keys)[selectedAlbumIndex]
            guard let images = photoAlbum[arraySet] else { return UICollectionViewCell() }
            guard let image = images?[indexPath.row] else { return UICollectionViewCell() }
            cell.updateView(image: image)
            return cell
    }
}

//MARK: -UICollectionView Delegate

extension PhotoalbumViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 108, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.albumCollectionView {
            self.selectedAlbumIndex = indexPath.row
        }
        photoCollectionView.reloadData()
    }
}

// MARK: - UIImagePicker Delegate
extension PhotoalbumViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        presenter.addImageToPhotoAlbum(image: image)
        self.dismiss(animated: true)
    }
}

// MARK: -Layout

extension PhotoalbumViewController {

    func addSubviews() {
        view.addSubview(topSeparatorView)
        view.addSubview(albumCollectionViewTitle)
        view.addSubview(albumCollectionView)
        view.addSubview(showAllAlbumsButton)
        view.addSubview(bottomSeparatorView)
        view.addSubview(photoCollectionViewTitle)
        view.addSubview(photoCollectionView)
    }

    func layout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            topSeparatorView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            topSeparatorView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 26),
            topSeparatorView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -26),
            topSeparatorView.heightAnchor.constraint(equalToConstant: 1),

            albumCollectionViewTitle.topAnchor.constraint(equalTo: topSeparatorView.bottomAnchor, constant: 15),
            albumCollectionViewTitle.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 28),
            albumCollectionViewTitle.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -280),
            albumCollectionViewTitle.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -632),

            showAllAlbumsButton.centerYAnchor.constraint(equalTo: albumCollectionViewTitle.centerYAnchor),
            showAllAlbumsButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 170),
            showAllAlbumsButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),

            albumCollectionView.topAnchor.constraint(equalTo: albumCollectionViewTitle.bottomAnchor, constant: 8),
            albumCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 28),
            albumCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            albumCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -540),

            bottomSeparatorView.topAnchor.constraint(equalTo: albumCollectionView.bottomAnchor, constant: 15),
            bottomSeparatorView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 26),
            bottomSeparatorView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -26),
            bottomSeparatorView.heightAnchor.constraint(equalToConstant: 1),

            photoCollectionViewTitle.topAnchor.constraint(equalTo: bottomSeparatorView.bottomAnchor, constant: 15),
            photoCollectionViewTitle.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 28),
            photoCollectionViewTitle.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -150),
            photoCollectionViewTitle.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -495),

            photoCollectionView.topAnchor.constraint(equalTo: photoCollectionViewTitle.bottomAnchor, constant: 15),
            photoCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 28),
            photoCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -28),
            photoCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}
