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


protocol CommentOrAnswer: Codable, Hashable {
    var text: String { get set }
    var commentor: String { get set }
    var date: String { get set }
    var likes: Int { get set }
}

struct FirebaseUser: Codable, Hashable {
    @DocumentID var documentID: String?
    var name: String
    var surname: String
    var identifier: String
    var job: String
    var subscribers: [String]
    var subscribtions: [String]
    var stories: [String]
    var image: String?
    var photoAlbum: [String]
    var sex: Bool
}

struct EachPost: Codable {
    @DocumentID var documentID: String?
    var text: String
    var image: String?
    var likes: Int
    var commentaries: Int
    var date: String
    var isCommentariesEnabled: Bool
    var isPinned: Bool
}

struct Comment: CommentOrAnswer {
    @DocumentID var documentID: String?
    var text: String
    var commentor: String
    var date: String
    var likes: Int
}

struct Answer: CommentOrAnswer {
    @DocumentID var documentID: String?
    var text: String
    var commentor: String
    var date: String
    var likes: Int
}
