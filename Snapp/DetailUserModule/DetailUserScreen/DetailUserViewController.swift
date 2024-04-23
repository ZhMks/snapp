//
//  DetailUserViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 22.04.2024.
//

import UIKit

class DetailUserViewController: UIViewController {

    //MARK: -PROPERTIES

    var presenter: DetailPresenter!

    private lazy var userImageView: UIImageView = {
        let userImageView = UIImageView()
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        return userImageView
    }()

    private lazy var userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.font = UIFont(name: "Inter-Medium", size: 18)
        userNameLabel.textColor = ColorCreator.shared.createTextColor()
        return userNameLabel
    }()

    private lazy var userJob: UILabel = {
        let userJob = UILabel()
        userJob.translatesAutoresizingMaskIntoConstraints = false
        userJob.font = UIFont(name: "Inter-Light", size: 14)
        userJob.textColor = .systemGray3
        return userJob
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
        let signalImage = UIImageView()
        signalImage.translatesAutoresizingMaskIntoConstraints = false
        signalImage.tintColor = .systemOrange
        return signalImage
    }()

    private lazy var messageButton: UIButton = {
        let messageButton = UIButton(type: .system)
        messageButton.translatesAutoresizingMaskIntoConstraints = false
        messageButton.backgroundColor = ColorCreator.shared.createButtonColor()
        messageButton.setTitle(.localized(string: "Сообщение"), for: .normal)
        messageButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        messageButton.layer.cornerRadius = 10.0
        return messageButton
    }()

    private lazy var subscriberButton: UIButton = {
        let messageButton = UIButton(type: .system)
        messageButton.translatesAutoresizingMaskIntoConstraints = false
        messageButton.backgroundColor = ColorCreator.shared.createButtonColor()
        messageButton.setTitle(.localized(string: "Подписаться"), for: .normal)
        messageButton.setTitleColor(ColorCreator.shared.createTextColor(), for: .normal)
        messageButton.layer.cornerRadius = 10.0
        return messageButton
    }()

    private lazy var topSeparatorView: UIView = {
        let topSeparatorView = UIView()
        topSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        topSeparatorView.layer.borderWidth = 1.0
        topSeparatorView.layer.borderColor = UIColor.systemGray2.cgColor
        return topSeparatorView
    }()

    private lazy var middleSeparatorView: UIView = {
        let middleSeparatorView = UIView()
        middleSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        middleSeparatorView.layer.borderWidth = 1.0
        middleSeparatorView.layer.borderColor = UIColor.systemGray2.cgColor
        return middleSeparatorView
    }()

    private lazy var bottomSeparatorView: UIView = {
        let bottomSeparatorView = UIView()
        bottomSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        bottomSeparatorView.layer.borderWidth = 1.0
        bottomSeparatorView.layer.borderColor = UIColor.systemGray2.cgColor
        return bottomSeparatorView
    }()

    private lazy var numberOfPosts: UILabel = {
        let numberOfPosts = UILabel()
        numberOfPosts.translatesAutoresizingMaskIntoConstraints = false
        numberOfPosts.textColor = .systemOrange
        return numberOfPosts
    }()

    private lazy var numberOfSubscriptions: UILabel = {
        let numberOfSubscriptions = UILabel()
        numberOfSubscriptions.translatesAutoresizingMaskIntoConstraints = false
        return numberOfSubscriptions
    }()

    private lazy var numberOfSubscribers: UILabel = {
        let numberOfSubscribers = UILabel()
        numberOfSubscribers.translatesAutoresizingMaskIntoConstraints = false
        return numberOfSubscribers
    }()

    private lazy var collectionViewTitle: UILabel = {
        let collectionViewTitle = UILabel()
        collectionViewTitle.translatesAutoresizingMaskIntoConstraints = false
        collectionViewTitle.text = .localized(string: "Фотографии") + "\(presenter.user.stories.count)"
        return collectionViewTitle
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var arrowButton: UIButton = {
        let arrowButton = UIButton(type: .system)
        arrowButton.translatesAutoresizingMaskIntoConstraints = false
        arrowButton.setBackgroundImage(UIImage(systemName: "chevron.right"), for: .normal)
        arrowButton.tintColor = ColorCreator.shared.createButtonColor()
        return arrowButton
    }()

    private lazy var postsTableView: UITableView = {
        let postsTableView = UITableView()
        postsTableView.translatesAutoresizingMaskIntoConstraints = false
        return postsTableView
    }()



    //MARK: -LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        layout()
    }

    //MARK: -FUNCS
    private func tuneNavigation() {
        
    }

}

// MARK: -OUTPUT PRESENTER

extension DetailUserViewController: DetailViewProtocol {

}


// MARK: -LAYOUT
extension DetailUserViewController {

    private func layout() {
        let safeArea = view.safeAreaLayoutGuide
    }

    private func addSubviews() {
        view.addSubview(topSeparatorView)
        view.addSubview(userImageView)
        view.addSubview(userNameLabel)
        view.addSubview(userJob)
        view.addSubview(detailInfo)
        view.addSubview(signalImage)
        view.addSubview(messageButton)
        view.addSubview(subscriberButton)
        view.addSubview(middleSeparatorView)
        view.addSubview(numberOfPosts)
        view.addSubview(numberOfSubscriptions)
        view.addSubview(numberOfSubscribers)
        view.addSubview(bottomSeparatorView)
        view.addSubview(collectionViewTitle)
        view.addSubview(arrowButton)
        view.addSubview(collectionView)
        view.addSubview(postsTableView)
    }
}


// MARK: -CollectionViewDataSource

extension DetailUserViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.user.stories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        return cell
    }
}

// MARK: -COllectionViewDelegate

extension DetailUserViewController: UICollectionViewDelegate {}

// MARK: -TABLEVIEWDATASOURCE

extension DetailUserViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
}

// MARK: -TABLEVIEWDELEGATE

extension DetailUserViewController: UITableViewDelegate {}
