//
//  FirebaseUser.swift
//  Snapp
//
//  Created by Максим Жуин on 03.04.2024.
//

import Foundation
import FirebaseAuth
import UIKit
import FirebaseFirestore

struct FirebaseUser: Codable {
    @DocumentID var documentID: String?
    var name: String
    var surname: String
    var identifier: String
    var job: String
    var subscribers: [String]
    var subscribtions: [String]
    var stories: [String]
    var image: String
    var photoAlbum: [String]
}

struct EachPost: Codable {
    var text: String
    var image: String?
    var likes: Int
    var views: Int
    var date: String
}
