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
            header.topAnchor.constraint(equalTo: self.topAnchor),
            header.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            header.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            header.widthAnchor.constraint(equalTo: self.widthAnchor),
        ])
        //header.setNeedsLayout()
        header.layoutIfNeeded()

        header.frame.size = header.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
        self.tableHeaderView = header
   
    }
}

