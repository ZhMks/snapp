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

enum ChangeStates {
    case name
    case job
    case city
    case interests
    case contacts
    case surname
}

protocol FireStoreServiceProtocol {
    func getUser(id: String, completion: @escaping (Result<FirebaseUser, Error>) -> Void)
    func getPosts(id: String, completion: @escaping (Result<[String : [String : EachPost]], Error>) -> Void)
    func getEachPost(id: String, completion: @escaping (Result<[String: EachPost], Error>) ->Void)
    func changeData(id: String, text: String, state: ChangeStates) async
}


final class FireStoreService: FireStoreServiceProtocol {


    func getUser(id: String, completion: @escaping (Result<FirebaseUser, Error>) -> Void) {
        let ref = Firestore.firestore().collection("Users").document(id)
        var firuser = FirebaseUser(name: "test",
                                   surname: "test",
                                   job: "test",
                                   subscribers: ["test"],
                                   subscriptions: ["test"],
                                   stories: ["test"],
                                   interests: ",",
                                   contacts: "fdfs",
                                   city: "TestCituy")
        firuser.id = ref.documentID
        ref.getDocument(as: FirebaseUser.self) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let user):
                firuser.name = user.name
                firuser.job = user.job
                firuser.stories = user.stories
                firuser.subscribers = user.subscribers
                firuser.subscriptions = user.subscriptions
                firuser.contacts = user.contacts
                firuser.city = user.city
                firuser.interests = user.interests
                firuser.surname = user.surname
                completion(.success(firuser))
            case .failure(let error):
                print("Error in decoding doc \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    func getPosts(id: String, completion: @escaping (Result<[String : [String : EachPost]], Error>) -> Void) {
        let ref = Firestore.firestore().collection("Users").document(id).collection("posts")
        var posts: [String : [String : EachPost]] = [:]

        ref.getDocuments { snapshot, error in
            if let error = error {
                print("error in getting doc \(error.localizedDescription)")
                completion(.failure(error))
            }

            if let snapshot = snapshot {
                for document in snapshot.documents {
                    self.getEachPost(id: document.documentID) { result in
                        switch result {
                        case .success(let success):
                            posts.updateValue(success, forKey: document.documentID)
                        case .failure(let failure):
                            completion(.failure(failure))
                        }
                    }
                }
                completion(.success(posts))
            }
        }
    }

    func getEachPost(id: String, completion: @escaping (Result<[String: EachPost], Error>) ->Void) {
        let postRef = Firestore.firestore().collection("Users").document(id).collection("posts").document(id)
        var postsArray: [String : EachPost] = [:]

            postRef.collection("PostsInThisDate").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            }

            if let snapshot = snapshot {
                var eachPost = EachPost(text: "", image: "", likes: 0, views: 0)
                for document in snapshot.documents {
                    do {
                        let firPost = try document.data(as: EachPost.self)
                        eachPost.image = firPost.image
                        eachPost.text = firPost.text
                        eachPost.likes = firPost.likes
                        eachPost.views = firPost.views
                        postsArray.updateValue(eachPost, forKey: document.documentID)
                    } catch {
                        completion(.failure(error))
                    }
                }
                completion(.success(postsArray))
            }
        }
    }

    func changeData(id: String, text: String, state: ChangeStates) async {
        
        let ref = Firestore.firestore().collection("Users").document(id)

        switch state {
        case .name:
            do {
                try await ref.updateData(["name" : text])
            } catch {
                print("error in updating \(error.localizedDescription)")
            }
        case .job:
            do {
                try await ref.updateData(["job" : text])
            } catch {
                print("error in updating \(error.localizedDescription)")
            }
        case .city:
            do {
                try await ref.updateData(["city" : text])
            } catch {
                print("error in updating \(error.localizedDescription)")
            }
        case .interests:
            do {
                try await ref.updateData(["interests" : text])
            } catch {
                print("error in updating \(error.localizedDescription)")
            }
        case .contacts:
            do {
                try await ref.updateData(["contacts" : text])
            } catch {
                print("error in updating \(error.localizedDescription)")
            }
        case .surname:
            do {
                try await ref.updateData(["surname" : text])
            } catch {
                print("error in updating \(error.localizedDescription)")
            }
        }
    }
}

