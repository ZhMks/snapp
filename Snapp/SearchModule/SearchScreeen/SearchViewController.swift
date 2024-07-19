//
//  SearchViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 22.04.2024.
//

import UIKit

class SearchViewController: UIViewController {


    // MARK: -Properties
    private lazy var allUsersTable: UITableView = {
        let allUsersTable = UITableView(frame: .zero, style: .insetGrouped)
        allUsersTable.translatesAutoresizingMaskIntoConstraints = false
        allUsersTable.delegate = self
        allUsersTable.dataSource = self
        allUsersTable.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        return allUsersTable
    }()

    var presenter: SearchPresenter!

    //MARK: -Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        layout()
        presenter.getAllUsers()
    }


    //MARK: -Funcs
}


//MARK: -Presenter Output

extension SearchViewController: SearchViewProtocol {

    func updateTableView() {
        allUsersTable.reloadData()
    }

    func goToNextVC(user: FirebaseUser, userID: String) {
        let detailVC = DetailUserViewController()
        let detailPresenter = DetailPresenter(view: detailVC, user: user, mainUserID: userID)
        detailVC.presenter = detailPresenter
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func showErrorAlert(error: String) {
        switch error {
        case  "Ошибка сервера":
            let alert = UIAlertController(title: .localized(string: "Ошибка"),
                                          message: .localized(string: "Не удалось загрузить пользователей"),
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: .localized(string: "Отмена"), style: .cancel)
            alert.addAction(action)
            navigationController?.present(alert, animated: true)
        case "Ошибка декодирования":
            let alert = UIAlertController(title: .localized(string: "Ошибка"),
                                          message: .localized(string: "Не удалось загрузить пользователей"),
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: .localized(string: "Отмена"), style: .cancel)
            alert.addAction(action)
            navigationController?.present(alert, animated: true)
        case "Посты отсутстуют":
            let alert = UIAlertController(title: .localized(string: "Ошибка"),
                                          message: .localized(string: "Не удалось загрузить пользователей"),
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: .localized(string: "Отмена"), style: .cancel)
            alert.addAction(action)
            navigationController?.present(alert, animated: true)
        default: return
        }
    }
}

// MARK: -TableView DataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.usersArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        guard let dataSource = presenter?.usersArray[indexPath.row] else { return UITableViewCell() }
        guard let avatarImage = dataSource.image else { return UITableViewCell() }
        cell.updateCell(image: avatarImage, name: dataSource.name, surname: dataSource.surname, job: dataSource.job)
        return cell
    }


}

// MARK: -TableView Delegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = presenter.usersArray[indexPath.row]
        presenter.showNextVC(user: user, userID: self.presenter.mainUserID)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


//MARK: -Layout

extension SearchViewController {

    private func addSubviews() {
        view.addSubview(allUsersTable)
    }

    private func layout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            allUsersTable.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 15),
            allUsersTable.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 25),
            allUsersTable.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            allUsersTable.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -15)
        ])
    }
}



