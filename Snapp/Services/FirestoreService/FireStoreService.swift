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
    func getAllUsers(completion: @escaping (Result<[FirebaseUser], Error>) -> Void)
    func getUser(id: String, completion: @escaping (Result<FirebaseUser, Error>) -> Void)
    func getPosts(sub: String, completion: @escaping (Result<[String : [String : EachPost]], Error>) -> Void)
    func getEachPost(userid: String, documentID: String, completion: @escaping (Result<[String: EachPost], Error>) ->Void)
    func changeData(id: String, text: String, state: ChangeStates) async
    func createPost(date: String, text: String, image: UIImage, for user: UserMainModel, completion: @escaping (Result<EachPost, Error>) -> Void)
    func saveImageIntoStorage(urlLink: StorageReference, photo: UIImage, for user: String, completion: @escaping (Result <URL, Error>) -> Void)
    func createUser(user: FirebaseUser, id: String)
}


final class FireStoreService: FireStoreServiceProtocol {


    func getAllUsers(completion: @escaping (Result<[FirebaseUser], Error>) -> Void) {
        let dbReference = Firestore.firestore().collection("Users")
        dbReference.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            }
            if let snapshot = snapshot {
                var usersArray: [FirebaseUser] = []
                do {
                    for document in snapshot.documents {
                        let currentUser = try document.data(as: FirebaseUser.self)
                        usersArray.append(currentUser)
                    }
                } catch {
                    completion(.failure(error))
                }
                completion(.success(usersArray))
            }
        }
    }

    func getUser(id: String, completion: @escaping (Result<FirebaseUser, Error>) -> Void) {
        let dbReference = Firestore.firestore().collection("Users").document(id)
        dbReference.getDocument { snapshot, error in
            if let error = error {
                print("Error in gettingUser: \(error.localizedDescription)")
                completion(.failure(error))
            }

            if let snapshot = snapshot {
                do {
                    let currentUser = try snapshot.data(as: FirebaseUser.self)
                    completion(.success(currentUser))
                } catch {
                    completion(.failure(error))
                }
            }
        }
    }

    func getPosts(sub: String, completion: @escaping (Result<[String : [String : EachPost]], Error>) -> Void) {
        let ref = Firestore.firestore().collection("Users").document(sub).collection("posts")
        var posts: [String : [String : EachPost]] = [:]

        ref.getDocuments { snapshot, error in
            if let error = error {
                print("error in getting doc \(error.localizedDescription)")
                completion(.failure(error))
            }

            if let documents = snapshot?.documents {
                for document in documents {
                    print(document.documentID)
                    self.getEachPost(userid: sub, documentID: document.documentID) { [weak self] result in
                        guard self != nil else { return }
                        switch result {
                        case .success(let success):
                            posts.updateValue(success, forKey: document.documentID)
                            completion(.success(posts))
                        case .failure(let failure):
                            completion(.failure(failure))
                        }
                    }
                }
            }
        }
    }

    func getEachPost(userid: String, documentID: String, completion: @escaping (Result<[String: EachPost], Error>) ->Void) {
        let postRef = Firestore.firestore().collection("Users").document(userid).collection("posts").document(documentID)
        var postsArray: [String : EachPost] = [:]

        postRef.getDocument { document, error in
            if let error = error {
                completion(.failure(error))
            }

            if let document = document {
                print(document.documentID)
                do {
                    let eachPost = try document.data(as: EachPost.self)
                    postsArray.updateValue(eachPost, forKey: document.documentID)
                    completion(.success(postsArray))
                } catch {
                    completion(.failure(error))
                }
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

    func createUser(user: FirebaseUser, id: String) {
        Firestore.firestore().collection("Users").document(id).setData([
            "name" : user.name,
            "job" : user.job,
            "city" : user.city,
            "contacts" : user.contacts,
            "interests" : user.interests,
            "surname" : user.surname,
            "subscribers" : user.subscribers,
            "stories" : user.stories,
            "subscribtions" : user.subscribtions,
            "image" : user.image,
            "nickName" : user.nickName
        ])
    }

    func saveImageIntoStorage(urlLink: StorageReference, photo: UIImage, for user: String, completion: @escaping (Result <URL, Error>) -> Void) {
        guard let imageData = photo.jpegData(compressionQuality: 0.7) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"

        urlLink.putData(imageData, metadata: metaData) { metada, error in
            guard let _ = metada else {
                completion(.failure(error!))
                return
            }

            urlLink.downloadURL { url, error in
                guard let url = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(url))
            }
        }
    }

    func createPost(date: String, text: String, image: UIImage, for user: UserMainModel, completion: @escaping (Result<EachPost, Error>) -> Void) {
        let docRef = Firestore.firestore().collection("Users").document(user.id!).collection("posts").document(date).collection("eachPost")
        let postRef = Storage.storage().reference().child("users").child(user.id!).child("posts").child(date)
        var fireStorePost = EachPost(text: "", image: "", likes: 0, views: 0)
        saveImageIntoStorage(urlLink: postRef, photo: image, for: user.id!) { result in
            switch result {
            case .success(let url):
                fireStorePost.image = url.absoluteString
                fireStorePost.text = text
                docRef.addDocument(data: [
                    "text" : fireStorePost.text,
                    "likes" : fireStorePost.likes,
                    "views" : fireStorePost.views,
                    "image" : fireStorePost.image
                ])
                completion(.success(fireStorePost))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }

    func saveSubscriber(mainUser: String, id: String) {
        let docRef = Firestore.firestore().collection("Users").document(mainUser)
        docRef.updateData(["subscribers" : id])
    }

    func saveUserStorie(user: UserMainModel, image: UIImage, date: String, completion: @escaping (Result <URL, Error>) -> Void) {
        print(user.id)
        let docRef = Firestore.firestore().collection("Users").document(user.id!)
        let postRef = Storage.storage().reference().child("users").child(user.id!).child("stories").child(date)

        saveImageIntoStorage(urlLink: postRef, photo: image, for: user.id!) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let url):
                docRef.updateData(["stories" : url])
                completion(.success(url))
            case .failure(let failure):
                print(failure.localizedDescription)
                completion(.failure(failure))
            }
        }
    }
}

