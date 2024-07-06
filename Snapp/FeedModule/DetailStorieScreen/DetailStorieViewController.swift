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
        storiesSCrollView.backgroundColor = .systemGray6
        storiesSCrollView.contentSize = CGSize(width: storiesSCrollView.frame.size.width, height: storiesSCrollView.frame.size.height)
        storiesSCrollView.delegate = self
        return storiesSCrollView
    }()

    private lazy var storiesPageControle: UIPageControl = {
        let storiesPageControle = UIPageControl()
        storiesPageControle.translatesAutoresizingMaskIntoConstraints = false
        storiesPageControle.backgroundStyle = .automatic
        storiesPageControle.pageIndicatorTintColor = .systemBackground
        storiesPageControle.currentPageIndicatorTintColor = .systemRed
        return storiesPageControle
    }()


    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        layout()
        presenter.fetchSubscribersStorie()
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
    }


}

// MARK: - ScrollView Delegate
extension DetailStorieViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        storiesPageControle.currentPage = Int(pageNumber)
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
