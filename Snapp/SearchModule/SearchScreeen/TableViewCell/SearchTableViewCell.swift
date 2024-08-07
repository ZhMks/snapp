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

    private lazy var userNameAndSurname: UILabel = {
        let userName = UILabel()
        userName.translatesAutoresizingMaskIntoConstraints = false
        userName.font = UIFont(name: "Inter-Light", size: 12)
        return userName
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
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        addViews()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: -FUNCS

    func addViews() {
        contentView.addSubview(userImage)
        contentView.addSubview(userNameAndSurname)
        contentView.addSubview(userJob)
    }

    func layout() {
        let safeArea = contentView.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            userImage.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            userImage.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            userImage.heightAnchor.constraint(equalToConstant: 69),
            userImage.widthAnchor.constraint(equalToConstant: 69),

            userNameAndSurname.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 15),
            userNameAndSurname.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 10),
            userNameAndSurname.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -50),
            userNameAndSurname.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -60),

            userJob.topAnchor.constraint(equalTo: userNameAndSurname.bottomAnchor, constant: 15),
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
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    userImage.image = success
                    updateImageView()
                }
            case .failure(_):
                let uiImage = UIImage(systemName: "checkmark")
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    userImage.image = uiImage
                }
            }
        }
        userNameAndSurname.text = "\(name)" + " \(surname)"
        userJob.text = job
    }

    func updateImageView() {
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = userImage.frame.size.height / 2
    }
}
