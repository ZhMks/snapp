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

        let height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let width = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width
        var frame = header.frame
        frame.size.height = height
        frame.size.width = width

        header.setNeedsLayout()
        header.layoutIfNeeded()

        header.frame = frame


    }
}


//tableHeaderView = header
//
//header.setNeedsLayout()
//header.layoutIfNeeded()
//
//let height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
//let width = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width
//var frame = header.frame
//frame.size.height = height
//frame.size.width = width
//header.frame = frame
//tableHeaderView = header


//tableHeaderView = header
//header.translatesAutoresizingMaskIntoConstraints = false
//
//NSLayoutConstraint.activate([
//    header.widthAnchor.constraint(equalTo: widthAnchor),
//    header.leadingAnchor.constraint(equalTo: leadingAnchor),
//    header.trailingAnchor.constraint(equalTo: trailingAnchor)
//])
//header.setNeedsLayout()
//header.layoutIfNeeded()
//header.frame.size = header.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
