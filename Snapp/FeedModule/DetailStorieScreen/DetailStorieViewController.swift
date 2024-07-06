//
//  DetailStorieViewController.swift
//  Snapp
//
//  Created by Максим Жуин on 06.07.2024.
//

import UIKit

class DetailStorieViewController: UIViewController {

    // MARK: - Properties
    var presenter: DetailStoriePresenter!

    private lazy var storiesScrollView: UIScrollView = {
        let storiesSCrollView = UIScrollView()
        storiesSCrollView.translatesAutoresizingMaskIntoConstraints = false
        storiesSCrollView.isPagingEnabled = true
        storiesSCrollView.showsHorizontalScrollIndicator = false
        storiesSCrollView.contentSize = CGSize(width: storiesSCrollView.frame.size.width, height: storiesSCrollView.frame.size.height)
        storiesSCrollView.delegate = self
        return storiesSCrollView
    }()

    private lazy var storiesPageControle: UIPageControl = {
        let storiesPageControle = UIPageControl()
        storiesPageControle.translatesAutoresizingMaskIntoConstraints = false
        storiesPageControle.pageIndicatorTintColor = .lightGray
        storiesPageControle.currentPageIndicatorTintColor = .white
        return storiesPageControle
    }()


    // MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tuneNavItem()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        layout()
        presenter.fetchSubscribersStorie()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

    // MARK: - Funcs

}

// MARK: - Presenter Output
extension DetailStorieViewController: DetailStorieViewProtocol {

    func showError(descr: String) {
        print()
    }

    func updateView(images: [UIImage]) {
        for (index, imageName) in images.enumerated() {
            let imageView = UIImageView(frame: CGRect(x: storiesScrollView.frame.size.width * CGFloat(index),
                                                      y: 0,
                                                      width: storiesScrollView.frame.size.width,
                                                      height: storiesScrollView.frame.size.height))
            imageView.image = imageName
            storiesPageControle.numberOfPages = images.count
            storiesPageControle.currentPage = 0
            storiesScrollView.addSubview(imageView)
        }
        storiesScrollView.contentSize = CGSize(width: view.bounds.width * CGFloat(images.count), height: view.bounds.height)

        storiesPageControle.numberOfPages = images.count
        storiesPageControle.currentPage = 0
    }

    func tuneNavItem() {
        self.navigationController?.navigationBar.isHidden = true
    }


}

// MARK: - ScrollView Delegate
extension DetailStorieViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.bounds.width)
        storiesPageControle.currentPage = Int(pageIndex)
    }
}


// MARK: - Layout

extension DetailStorieViewController {
    private func addSubviews() {
        view.addSubview(storiesPageControle)
        view.addSubview(storiesScrollView)
    }

    private func layout() {
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            storiesPageControle.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 5),
            storiesPageControle.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            storiesPageControle.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),

            storiesScrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            storiesScrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            storiesScrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            storiesScrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}
