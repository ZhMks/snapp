//
//  ExtensionTableVIew.swift
//  Snapp
//
//  Created by Максим Жуин on 04.05.2024.
//

import UIKit


extension UITableView {
    func setAndLayout(header: UIView) {
        tableHeaderView = header
        header.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: topAnchor),
            header.leadingAnchor.constraint(equalTo: leadingAnchor),
            header.trailingAnchor.constraint(equalTo: trailingAnchor),
            header.centerXAnchor.constraint(equalTo: centerXAnchor),
            header.widthAnchor.constraint(equalTo: widthAnchor),
        ])

        header.layoutIfNeeded()

        header.frame.size = header.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
        tableHeaderView = header
    }
}

