//
//  FilesViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 12.07.2024.
//

import UIKit
import UniformTypeIdentifiers

class FilesViewController: UIViewController {

    // MARK: - Properties

    var presenter: FilesPresenter!

    private lazy var pickDocumentButton: UIButton = {
        let pickDocumentButton = UIButton(type: .system)
        pickDocumentButton.translatesAutoresizingMaskIntoConstraints = false
        pickDocumentButton.setTitle("Pick Document", for: .normal)
        pickDocumentButton.titleLabel?.font = UIFont(name: "Inter-Medium", size: 14)
        pickDocumentButton.addTarget(self, action: #selector(pickeDocumentButtonTapped), for: .touchUpInside)
        return pickDocumentButton
    }()

    private lazy var filesCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: 80, height: 80)
        flowLayout.minimumInteritemSpacing = 10.0
        flowLayout.minimumLineSpacing = 15.0
        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let filesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        filesCollectionView.delegate = self
        filesCollectionView.dataSource = self
        filesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        filesCollectionView.register(FilesCollectionViewCell.self, forCellWithReuseIdentifier: FilesCollectionViewCell.identifier)
        return filesCollectionView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tuneNavItem()
        addSubviews()
        layout()
        presenter.addUserListener()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.removeUserListener()
    }

    // MARK: - Funcs
    @objc func pickeDocumentButtonTapped() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.item], asCopy: false)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet

        self.present(documentPicker, animated: true, completion: nil)
    }

    @objc func addFileButtonTapped() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.item])
        documentPicker.modalPresentationStyle = .formSheet
        documentPicker.delegate = self
        self.present(documentPicker, animated: true)
    }

    @objc func dismissViewController() {
        navigationController?.popViewController(animated: true)
    }


    func tuneNavItem() {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        let leftArrowButton = UIButton(type: .system)
        leftArrowButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        leftArrowButton.setBackgroundImage(UIImage(systemName: "arrow.left"), for: .normal)
        leftArrowButton.tintColor = .systemOrange
        leftArrowButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        leftView.addSubview(leftArrowButton)
        let leftBarButton = UIBarButtonItem(customView: leftView)
        let rightBarButton = UIBarButtonItem(title: "Добавить", style: .done, target: self, action: #selector(addFileButtonTapped))
        rightBarButton.tintColor = .systemOrange
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.leftBarButtonItem = leftBarButton
    }

}

// MARK: - Presenter output
extension FilesViewController: FilesViewProtocol {
    func updateData() {
        pickDocumentButton.isHidden = true
        filesCollectionView.reloadData()
        print("Successfully reloaded")
    }


}

// MARK: - UICollectionView DataSource
extension FilesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let number = presenter.decodedObjects?.keys.count else { return 0 }
        return number
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilesCollectionViewCell.identifier, for: indexPath) as? FilesCollectionViewCell else { return UICollectionViewCell() }
        guard let decodedObjects = presenter.decodedObjects else { return UICollectionViewCell() }
        let keyForObject = Array(decodedObjects.keys)[indexPath.row]
        guard let dataForCell = decodedObjects[keyForObject] else { return UICollectionViewCell() }
        cell.updateDataForCell(object: dataForCell, name: keyForObject)
        return cell
    }
}

// MARK: - UICollectionView Delegate
extension FilesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let decodedObjects = presenter.decodedObjects else { return }
        let keyForObject = Array(decodedObjects.keys)[indexPath.row]
        guard let dataForCell = decodedObjects[keyForObject] else { return }
        FileManagerService.saveImagesAndStringsToDocuments(object: dataForCell, key: keyForObject) { [weak self] url in
            guard let self = self else { return }
            guard let url = url else { return }
            FileManagerService.presentDocumentPicker(for: url, from: self)
        }
    }
}

// MARK: - DocumentPicker Delegate
extension FilesViewController: UIDocumentPickerDelegate {

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let localFile = urls.first else { return }
        print(localFile.lastPathComponent)
        presenter.putFileToStorage(file: localFile)
    }

}

// MARK: - Layout
extension FilesViewController {
    private func addSubviews() {
        view.addSubview(pickDocumentButton)
        view.addSubview(filesCollectionView)
    }

    private func layout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            pickDocumentButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            pickDocumentButton.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),

            filesCollectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            filesCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            filesCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            filesCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}
