//
//  FireStoreService.swift
//  Snapp
//
//  Created by Максим Жуин on 05.04.2024.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift

protocol FireStoreServiceProtocol {
    func getUser(id: String, completion: @escaping (Result<FirebaseUser, Error>) -> Void)
    func getPosts(id: String, completion: @escaping (Result<[EachPost], Error>) -> Void)
}


final class FireStoreService: FireStoreServiceProtocol {

    func getUser(id: String, completion: @escaping (Result<FirebaseUser, Error>) -> Void) {
        let ref = Firestore.firestore().collection("Users").document(id)
        let docoder = JSONDecoder()
        var firuser = FirebaseUser(name: "", surname: "", job: "", subscribers: [""], subscriptions: [""], stories: [""], posts: [])
        ref.getDocument(as: FirebaseUser.self) { [weak self] result in
            guard let self else { return }
            firuser.id = ref.documentID
            switch result {
            case .success(let user):
                firuser.name = user.name
                firuser.job = user.job
                firuser.stories = user.stories
                firuser.subscribers = user.subscribers
                firuser.subscriptions = user.subscriptions
                getPosts(id: firuser.id!) { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success(let success):
                        firuser.posts = success
                        completion(.success(firuser))
                    case .failure(let failure):
                        print("Error in decoding doc \(failure.localizedDescription)")
                    }
                }
            case .failure(let error):
                print("Error in decoding doc \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    func getPosts(id: String, completion: @escaping (Result<[EachPost], Error>) -> Void) {
        let ref = Firestore.firestore().collection("Users").document(id).collection("posts")
        let decoder = JSONDecoder()
        var posts: [EachPost] = []

        ref.getDocuments { snapshot, error in
            if let error = error {
                print("error in getting doc \(error.localizedDescription)")
            }

            if let snapshot = snapshot {
                var eachPost = EachPost(date: "", text: "", image: "", likes: 0, views: 0)
                for document in snapshot.documents {
                    do {
                        let firpost = try document.data(as: EachPost.self)
                        eachPost.date = firpost.date
                        eachPost.text = firpost.text
                        eachPost.image = firpost.image
                        eachPost.likes = firpost.likes
                        eachPost.views = firpost.views
                        posts.append(eachPost)
                        completion(.success(posts))
                    } catch {
                        print("error in getting data from doc \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
