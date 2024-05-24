//
//  PhotoalbumViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 20.05.2024.
//

import UIKit

class PhotoalbumViewController: UIViewController {

    // MARK: -PROPERTIES

    var presenter: PhotoalbumPresenter!

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
        return albumCollectionView
    }()

    private lazy var showAllAlbumsButton: UIButton = {
        let showAllAlbumsButton = UIButton(type: .system)
        showAllAlbumsButton.translatesAutoresizingMaskIntoConstraints = false
        showAllAlbumsButton.setTitle(.localized(string: "Показать все"), for: .normal)
        showAllAlbumsButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
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
        photoCollectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier)
        return photoCollectionView
    }()

    // MARK: -LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        layout()
        tuneNavItem()
        view.backgroundColor = .systemBackground
    }

    // MARK: -FUNCS

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

        let textView = UIView(frame: CGRect(x: 0, y: 0, width: 350, height: 30))
        let title = UILabel(frame: CGRect(x: 40, y: 0, width: 250, height: 30))
        title.text = .localized(string: "Фотографии")
        title.font = UIFont(name: "Inter-Medium", size: 14)
        textView.addSubview(title)
        textView.addSubview(leftArrowButton)
        let leftButton = UIBarButtonItem(customView: textView)
        self.navigationItem.leftBarButtonItem = leftButton
    }

    @objc func addImageToAlbum() {

    }

    @objc func dismissController() {
        self.navigationController?.popViewController(animated: true)
    }
}


    // MARK: -PRESENTEROUTPUT
extension PhotoalbumViewController: PhotoalbumViewProtocol {
    func showError(error: String) {
        print(error)
    }
    
    func updateCollectionView() {
        photoCollectionView.reloadData()
    }
}


//MARK: -UICOLLECTIONVIEWDATASOURCE
extension PhotoalbumViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.photoAlbum.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.identifier, for: indexPath) as? ProfileCollectionViewCell else { return UICollectionViewCell() }
        let image = presenter.photoAlbum[indexPath.row]
        cell.updateView(image: image)
        return cell
    }
}

//MARK: -UICOLLECTIONVIEWDELEGATE

extension PhotoalbumViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 108, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    }
}

// MARK: -LAYOUT

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
            photoCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -80),
            photoCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}
