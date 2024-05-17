//
//  SearchTableViewCell.swift
//  Snapp
//
//  Created by Максим Жуин on 22.04.2024.
//

import UIKit


final class SearchTableViewCell: UITableViewCell {

    // MARK: -PROPERTIES

    static let identifier = "SearchTableViewCell"

    private lazy var userImage: UIImageView = {
        let userImage = UIImageView()
        userImage.translatesAutoresizingMaskIntoConstraints = false
        return userImage
    }()

    private lazy var userName: UILabel = {
        let userName = UILabel()
        userName.translatesAutoresizingMaskIntoConstraints = false
        userName.font = UIFont(name: "Inter-Light", size: 12)
        return userName
    }()

    private lazy var userSurname: UILabel = {
        let userSurname = UILabel()
        userSurname.translatesAutoresizingMaskIntoConstraints = false
        userSurname.font = UIFont(name: "Inter-Light", size: 12)
        return userSurname
    }()

    private lazy var userJob: UILabel = {
        let userJob = UILabel()
        userJob.translatesAutoresizingMaskIntoConstraints = false
        userJob.font = UIFont(name: "Inter-Bold", size: 8)
        userJob.textColor = .systemGray4
        return userJob
    }()

    // MARK: -LIFECYCLE

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addViews()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: -FUNCS

    func addViews() {
        contentView.addSubview(userImage)
        contentView.addSubview(userName)
        contentView.addSubview(userSurname)
        contentView.addSubview(userJob)
    }

    func layout() {
        let safeArea = contentView.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            userImage.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            userImage.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            userImage.heightAnchor.constraint(equalToConstant: 69),
            userImage.widthAnchor.constraint(equalToConstant: 69),

            userName.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 15),
            userName.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 10),
            userName.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -50),
            userName.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -60),

            userSurname.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 15),
            userSurname.leadingAnchor.constraint(equalTo: userName.trailingAnchor, constant: 10),
            userSurname.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            userSurname.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -60),

            userJob.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 15),
            userJob.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 10),
            userJob.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            userJob.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -30)
        ])
    }


    func updateCell(image: String, name: String, surname: String, job: String) {
        let networkService = NetworkService()
        networkService.fetchImage(string: image) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                let uiImage = UIImage(data: success)
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    userImage.image = uiImage
                    updateImageView()
                }
            case .failure(_):
                let uiImage = UIImage(systemName: "checkmark")
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    userImage.image = uiImage
                }
            }
        }
        userName.text = name
        userSurname.text = surname
        userJob.text = job
    }

    func updateImageView() {
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = userImage.frame.size.height / 2
    }
}
