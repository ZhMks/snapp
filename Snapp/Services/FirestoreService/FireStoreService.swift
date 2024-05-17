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

enum PostErrors: Error {
    case empty
    case errorInDecode
    case getError

    var description: String {
        switch self {
        case .getError:
            "Ошибка сервера"
        case .empty:
            "Посты отсутстуют"
        case .errorInDecode:
            "Ошибка декодирования"
        }
    }
}

protocol FireStoreServiceProtocol {
    func getAllUsers(completion: @escaping (Result<[FirebaseUser], Error>) -> Void)
    func getUser(id: String, completion: @escaping (Result<FirebaseUser, AuthorisationErrors>) -> Void)
    func getPosts(sub: String, completion: @escaping (Result<[EachPost], PostErrors>) -> Void)
    func changeData(id: String, text: String, state: ChangeStates) async
    func createPost(date: String, text: String, image: UIImage?, for user: String, completion: @escaping (Result<EachPost, Error>) -> Void)
    func saveImageIntoStorage(urlLink: StorageReference, photo: UIImage, completion: @escaping (Result <URL, Error>) -> Void)
    func createUser(user: FirebaseUser, id: String)
    func saveSubscriber(mainUser: String, id: String)
    func saveImageIntoPhotoAlbum(image: String, user: String)
}


final class FireStoreService: FireStoreServiceProtocol {


    func getAllUsers(completion: @escaping (Result<[FirebaseUser], Error>) -> Void) {
        let dbReference = Firestore.firestore().collection("Users")
        dbReference.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            }
            if let snapshot = snapshot {
                let dispatchGroup = DispatchGroup()
                var usersArray: [FirebaseUser] = []
                do {
                    dispatchGroup.enter()
                    for document in snapshot.documents {
                        let currentUser = try document.data(as: FirebaseUser.self)
                        usersArray.append(currentUser)
                    }
                    dispatchGroup.leave()
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
                dispatchGroup.notify(queue: .main) {
                    completion(.success(usersArray))
                }
            }
        }
    }

    func getUser(id: String, completion: @escaping (Result<FirebaseUser, AuthorisationErrors>) -> Void) {
        let dbReference = Firestore.firestore().collection("Users")
        dbReference.getDocuments { snapshot, error in
            if let error = error {
                print("Error in gettingUser: \(error.localizedDescription)")
                completion(.failure(.invalidCredential))
            }

            if let snapshot = snapshot {
                if snapshot.documents.isEmpty {
                    completion(.failure(.userAlreadyExist))
                }
                for document in snapshot.documents {
                    if document.documentID == id {
                        do {
                            let currentUser = try document.data(as: FirebaseUser.self)
                            completion(.success(currentUser))
                        } catch let DecodingError.dataCorrupted(context) {
                            print(context)
                        } catch let DecodingError.keyNotFound(key, context) {
                            print("Key '\(key)' not found:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                        } catch let DecodingError.valueNotFound(value, context) {
                            print("Value '\(value)' not found:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                        } catch let DecodingError.typeMismatch(type, context)  {
                            print("Type '\(type)' mismatch:", context.debugDescription)
                            print("codingPath:", context.codingPath)
                        } catch {
                            print("error: ", error)
                        }
                    } else {
                        completion(.failure(.invalidCredential))
                    }
                }
            }
        }
    }

    func getPosts(sub: String, completion: @escaping (Result<[EachPost], PostErrors>) -> Void)  {
        print(sub)

        let refDB = Firestore.firestore().collection("Users").document(sub).collection("posts")
        var posts: [EachPost] = []
        
        refDB.getDocuments { snapshot, error in
            
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.getError))
            }
            let dispatchGroup = DispatchGroup()
            if let snapshot = snapshot {
                if snapshot.documents.isEmpty {
                    return
                }
                dispatchGroup.enter()
                for document in snapshot.documents {
                    do {
                        let eachPost = try document.data(as: EachPost.self)
                        posts.append(eachPost)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                dispatchGroup.leave()
            }
            dispatchGroup.notify(queue: .main) {
                completion(.success(posts))
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
        do {
            try Firestore.firestore().collection("Users").document(id).setData(from: user)
        } catch {
            print(error.localizedDescription)
        }
    }

    func saveImageIntoStorage(urlLink: StorageReference, photo: UIImage, completion: @escaping (Result <URL, Error>) -> Void) {
        guard let imageData = photo.jpegData(compressionQuality: 0.5) else { return }
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

    func createPost(date: String, text: String, image: UIImage?, for user: String, completion: @escaping (Result<EachPost, Error>) -> Void) {
        let postRef = Firestore.firestore().collection("Users").document(user).collection("posts")
        var fireStorePost = EachPost(text: "", image: "", likes: 0, views: 0, date: date)

        if let image = image {
            let postStorageRef = Storage.storage().reference().child("users").child(user).child("posts").child(date).child(image.description)
            saveImageIntoStorage(urlLink: postStorageRef, photo: image) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let url):
                    fireStorePost.image = url.absoluteString
                    fireStorePost.text = text
                    do {
                        try postRef.addDocument(from: fireStorePost)
                        completion(.success(fireStorePost))
                    } catch {
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
        } else {
            fireStorePost.text = text
            do {
                try postRef.addDocument(from: fireStorePost)
                completion(.success(fireStorePost))
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func saveSubscriber(mainUser: String, id: String) {
        let docRef = Firestore.firestore().collection("Users").document(mainUser)
        docRef.updateData(["subscribtions" : FieldValue.arrayUnion([id])])
        let selfRef = Firestore.firestore().collection("Users").document(id)
        selfRef.updateData(["subscribers" : FieldValue.arrayUnion([mainUser])])
    }

    func saveImageIntoPhotoAlbum(image: String, user: String) {
        let docRef = Firestore.firestore().collection("Users").document(user)
        docRef.updateData(["photoAlbum" : FieldValue.arrayUnion([image])])
    }
}

