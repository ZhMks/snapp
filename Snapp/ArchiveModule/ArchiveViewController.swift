//
//  ArchiveViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 15.06.2024.
//

import UIKit

class ArchiveViewController: UIViewController {

    // MARK: - Properties
    var presenter: ArchivePresenter!

    private lazy var archivedTableView: UITableView =  {
        let archivedTableView = UITableView()
        archivedTableView.translatesAutoresizingMaskIntoConstraints = false
        archivedTableView.delegate = self
        archivedTableView.dataSource = self
        archivedTableView.register(PostTableCell.self, forCellReuseIdentifier: PostTableCell.identifier)
        return archivedTableView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        layoutViews()
    }

}

// MARK: - Presenter Output
extension ArchiveViewController: ArchiveViewProtocol {

    func showError(error: String) {
        let uiAlertController = UIAlertController(title: .localized(string: "Ошибка"), message: .localized(string: "\(error)"), preferredStyle: .alert)
        let uiAlertAction = UIAlertAction(title: .localized(string: "Отмена"), style: .cancel)
        uiAlertController.addAction(uiAlertAction)
        self.navigationController?.present(uiAlertController, animated: true)
    }

    func updateDataView() {
        self.archivedTableView.reloadData()
    }


}

//MARK: - TableView DataSource

extension ArchiveViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let number = presenter.posts?.count else { return 0 }
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableCell.identifier, for: indexPath) as? PostTableCell else { return UITableViewCell() }
        guard let dataforCell = presenter.posts?[indexPath.row] else { return UITableViewCell() }
        cell.updateView(post: dataforCell, user: self.presenter.mainUser, date: dataforCell.date, firestoreService: self.presenter.firestoreService, state: .profileState)
        return cell
    }
    

}

// MARK: - TableView Delegate

extension ArchiveViewController: UITableViewDelegate {

}

// MARK: - Layout

extension ArchiveViewController {
    private func addSubviews() {
        view.addSubview(archivedTableView)
    }

    private func layoutViews() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            archivedTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            archivedTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            archivedTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            archivedTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            archivedTableView.widthAnchor.constraint(equalTo: safeArea.widthAnchor)
        ])
    }
}
