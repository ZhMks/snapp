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
    func getEachPost(userid: String, documentid: String, completion: @escaping (Result<[String: EachPost], Error>) ->Void)
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
                                   city: "TestCituy",
                                   image: "")
        ref.getDocument(as: FirebaseUser.self) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let user):
                firuser.id = id
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
                    self.getEachPost(userid: id, documentid: document.documentID) { result in
                        switch result {
                        case .success(let success):
                            print(success.keys)
                            print(success.values)
                            posts.updateValue(success, forKey: document.documentID)
                        case .failure(let failure):
                            completion(.failure(failure))
                        }
                        completion(.success(posts))
                    }
                }
            }
        }
    }

    func getEachPost(userid: String, documentid: String, completion: @escaping (Result<[String: EachPost], Error>) ->Void) {
        let postRef = Firestore.firestore().collection("Users").document(userid).collection("posts").document(documentid)
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

    func createUser(user: FirebaseUser) {
    print(user)
     Firestore.firestore().collection("Users").document(user.id!).setData([
            "name" : user.name,
            "job" : user.job,
            "city" : user.city,
            "contacts" : user.contacts,
            "interests" : user.interests,
            "surname" : user.surname,
            "subscribers" : user.subscribers,
            "stories" : user.stories,
            "subsribtions" : user.subscriptions,
            "image" : user.image
        ])
    }

    func saveImageIntoStorage(photo: UIImage, for user: String, completion: @escaping (Result <URL, Error>) -> Void) {
        let ref = Storage.storage().reference().child("users").child(user).child("avatar")
        guard let imageData = photo.jpegData(compressionQuality: 0.7) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"

        ref.putData(imageData, metadata: metaData) { metada, error in
            guard let metadata = metada else {
                completion(.failure(error!))
                return
            }

            ref.downloadURL { url, error in
                guard let url = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(url))
            }
        }


    }
}

