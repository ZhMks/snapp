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
    case identifier
    case interests
    case contacts
    case surname
    case storie
    case dateOfBirth
    case files
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
    // MARK: - Функции для работы с пользователем

    /// Возвращает все пользователей из папки "Users" из БД Firebase
    /// - Parameter completion: -
    func getAllUsers(completion: @escaping (Result<[FirebaseUser], Error>) -> Void)

    /// Возвращает определенного пользователя по его id из БД.
    /// - Parameters:
    ///   - id: id пользователя. В БД - это documentID.
    ///   - completion: Возвращает либо пользователя, либо ошибку.
    func getUser(id: String, completion: @escaping (Result<FirebaseUser, AuthorisationErrors>) -> Void)

    /// Создает пользователя в БД из структуры FirebaseUser.
    /// - Parameters:
    ///   - user: Структура FirebaseUser
    ///   - id: uid Который мы получаем после авторизации в Firebase.
    func createUser(user: FirebaseUser, id: String)


    /// Сохраняем подписчика для пользователя.
    /// - Parameters:
    ///   - mainUser: uid Основного пользователя, который был авторизован в Firebase
    ///   - id: uid пользователя, которому записывается подписчик.
    func saveSubscriber(mainUser: String, id: String)

    /// Добавляет обсервера для конкретного пользователя. Позволяет обновлять данные в режиме реального времени.
    /// - Parameters:
    ///   - user: uid пользователя, которому добавляем обсервера.
    ///   - completion: Возвращает обновленного пользователя из БД.
    func addSnapshotListenerToUser(for user: String, completion: @escaping (Result<FirebaseUser, Error>) -> Void)
    func removeListenerForUser()


    /// Функция для обновления полей в документе пользователя в БД.
    /// - Parameters:
    ///   - id: uid пользователя, которому обновляем данные в БД.
    ///   - text: Тк в документе лежат только строки, то тут мы пишем текст, который будем отправлять в БД.
    ///   - state: Указываем к какому из полей отностится обновление.
    func changeData(id: String, text: String, state: ChangeStates)

    // MARK: - Функции для работы с постом

    /// Получаем все посты из папки "Posts" для конкретного пользователя.
    /// - Parameters:
    ///   - sub: uid пользователя в БД.
    ///   - completion: Возвращает либо массив постов, либо ошибку.
    func getPosts(sub: String, completion: @escaping (Result<[EachPost], PostErrors>) -> Void)

    /// Функция для создания поста.
    /// - Parameters:
    ///   - date: Дата создания поста
    ///   - text: Текст самого поста
    ///   - image: Текстовое описание изображения. По идее тут можно использовать имя изображения, но я не понял как его получить из ImagePicker.
    ///   - user: uid пользователя для которого создаем пост.
    ///   - completion: Возвращет либо созданный пост из БД, либо ошибку.
    func createPost(date: String, text: String, image: UIImage?, for user: String, completion: @escaping (Result<EachPost, Error>) -> Void)


    /// Функция для добавления комментариев к посту.
    /// - Parameters:
    ///   - mainUser: uid пользователя для которого оставляется комментарий.
    ///   - text: Текст комментария
    ///   - documentID: documentID из БД, к которому будет добавлени комментарий.
    ///   - commentor: uid пользователя, который оставляет комментарий.
    ///   - completion: Возвращает либо комментарий, либо ошибку.
    func addComment(mainUser: String, text: String, documentID: String, commentor: String, completion: @escaping (Result<Comment, Error>) -> Void)

    /// Получаем все комментарии для определенного поста.
    /// - Parameters:
    ///   - post: documentID поста из БД.
    ///   - user: uid пользователя, который содержит пост.
    ///   - completion: Возвращает либо комментарии, либо ошибку.
    func getComments(post: String, user: String, completion: @escaping (Result<[Comment], Error>) -> Void)

    /// Добавляем ответы на комментарии.
    /// - Parameters:
    ///   - postID: docuemntID поста в БД Firebase.
    ///   - user: uid пользователя для которого загружаем ответы.
    ///   - commentID: documentID комментария, который содержит коллекцию Ответы в БД.
    ///   - answer: сруктура ответ, которую записываем в БД.
    ///   - completion: Возвращает либо ответ, либо ошибку.
    func addAnswerToComment(postID: String, user: String, commentID: String, answer: Answer, completion: @escaping (Result<Answer, Error>) -> Void)

    /// Получаем ответы на комментарии.Тк в Firebase все лежит по принципу: document > collection > document. То просто так добраться до ответов через комментарии нельзя. Нужна новая ссылка.
    /// - Parameters:
    ///   - post: documentID поста в БД Firebase.
    ///   - comment: documentID комментария в БД Firebase.
    ///   - user: uid пользователя в БД.
    ///   - completion: Возвращает либо ответы, либо ошибку.
    func getAnswers(post: String, comment: String, user: String, completion: @escaping (Result<[Answer], Error>) -> Void)

    /// Добавляем пост в "Любимое"
    /// - Parameters:
    ///   - post: documentID поста в БД.
    ///   - user: uid пользователя в БД.
    func saveIntoFavourites(post: EachPost, for mainUser: String, user: String, completion: @escaping(Result<Bool, Error>) -> Void)

    /// Функция для получения ссылки на пост из БД.
    /// - Parameters:
    ///   - id: documentID поста в БД.
    ///   - user: uid пользователя в БД.
    /// - Returns: Возвращает ссылку.
    func getDocLink(for id: String, user: String) -> String

    /// Функция для отключения возможности комментирования поста. Меняем параметр в БД с true на false.
    /// - Parameters:
    ///   - id: documentID поста.
    ///   - user: uid авторизованного пользователя.
    func disableCommentaries(id: String, user: String)

    /// Функция для добавления поста в папку Archives.
    /// - Parameters:
    ///   - post: documentID поста в БД.
    ///   - user: uid авторизованного пользователя.
    ///   - completion: Возвращает либо пост, либо ошибку.
    func addDocToArchives(post: EachPost, user: String, completion: @escaping (Result<EachPost, Error>) -> Void)

    /// Функция для добавления обсервера к постам.
    /// - Parameters:
    ///   - user: uid пользователя из БД.
    ///   - completion: возвращает либо массив постов, либо ошибку.
    func addSnapshotListenerToPosts(for user: String, completion: @escaping (Result<[EachPost], Error>) -> Void)
    func removeListenerForPosts()

    /// Функция для добавления обсервера к определенному посту. Тк у нас есть детальная страница поста, то использовать общую функцию постов не представляется возможным, тк нужна определенная ссылка, чтобы получить документ.
    /// - Parameters:
    ///   - docID: documentID поста из БД.
    ///   - userID: uid пользователя из БД.
    ///   - completion: Возвращает обновленный пост или ошибку декодирования.
    func addSnapshotListenerToCurrentPost(docID: String, userID: String, completion: @escaping (Result<EachPost, Error>) -> Void)
    func removeListenerForCurrentPost()

    /// Функция для получения постов из папки "Любимое".
    /// - Parameters:
    ///   - user: uid пользователя из БД.
    ///   - completion: возвращает либо массив постов, либо ошибку.
    func fetchFavourites(user: String, completion: @escaping (Result<[EachPost], Error>) -> Void)

    /// Функция для изменения поля isPinned в БД.
    /// - Parameters:
    ///   - user: uid авторизованного пользователя.
    ///   - docID: documentID поста из БД.
    func pinPost(user: String, docID: String)


    /// Функция для добавления лайков к посту.
    /// - Parameters:
    ///   - user: uid пользователя из БД.
    ///   - mainUser: uid текущего авторизованного пользователя.
    ///   - post: documentID поста из БД.
    func incrementLikesForPost(user: String, mainUser: String, post: String)


    /// Функция для удаления лайков у поста.
    /// - Parameters:
    ///   - user: uid пользователя из БД.
    ///   - mainUser: uid текущего авторизованного пользователя.
    ///   - post: documentID поста из БД.
    func decrementLikesForPost(user: String, mainUser: String, post: String)

    func incrementLikesForAnswer(answerID: String, user: String, postID: String, commentID: String, mainUserID: String)

    func incrementLikesForComment(commentID: String, user: String, postID: String, mainUserID: String)

    func decrementLikesForAnswer(answerID: String, user: String, postID: String, commentID: String, mainUserID: String)

    func decrementLikesForComment(commentID: String, user: String, postID: String, mainUserID: String)

    /// Функция для получения массива лайкнувших пост пользователей.
    /// - Parameters:
    ///   - user: uid пользователя в БД.
    ///   - post: documentID поста в БД.
    ///   - completion: возвращает либо массив лайков, либо ошибку.
    func getNumberOfLikesInpost(user: String, post: String, completion: @escaping (Result <[Like], Error>) -> Void)

    /// Функция для получения массива постов из папки Archives.
    /// - Parameters:
    ///   - user: uid пользователя в БД.
    ///   - completion: возвращает либо массив постов, либо ошибку.
    func fetchArchives(user: String, completion: @escaping(Result<[EachPost], Error>) -> Void)

    /// Функция  для удаления поста.
    /// - Parameters:
    ///   - docID: documentID поста, который собираемся удалить.
    ///   - user: uid авторизованного пользователя.
    ///   - completion: возвращает либо успех, либо ошибку.
    func deleteDocument(docID: String, user: String, completion: @escaping (Result<Bool, Error>) -> Void)

    /// Функция для удаления подписки на пользователя.
    /// - Parameters:
    ///   - sub: uid пользователя из БД.
    ///   - user: uid авторизованного пользователя.
    func removeSubscribtion(sub: String, for user: String)


    /// Функция для удаления подписчика у пользователя.
    /// - Parameters:
    ///   - sub: uid пользователя из БД.
    ///   - user: uid авторизованного пользователя.
    func removeSubscriber(sub: String, for user: String)


    /// Функция для добавления поста в Закладки.
    /// - Parameters:
    ///   - mainUser: uid текщуего авторизованного пользователя.
    ///   - user: uid пользователя из БД.
    ///   - post: структура post, которую добавляем в БД.
    func saveToBookMarks(mainUser: String, user: String, post: EachPost, completion: @escaping(Result<Bool, Error>) -> Void)


    /// Функция для получения постов из папки "Закладки"
    /// - Parameters:
    ///   - user: uid текущего авторизованного пользователя.
    ///   - completion: возвращает либо массив постов, либо ошибку.
    func fetchBookmarkedPosts(user: String, completion: @escaping (Result<[EachPost], Error>) -> Void)


    /// Функция для удаления поста из папки "Закладки"
    /// - Parameters:
    ///   - user: uid текущего авторизованного пользователя.
    ///   - post: структура, которую удаляем.
    func removeFromFavourites(user: String, post: EachPost)

    // MARK: -  Функции для работы с изображением

    /// Функция для добавления изображения в папку Photoalbum в Firebase Storage.
    /// - Parameters:
    ///   - urlLink: Sotrage Reference. (Ссылка на папку в БД, куда кладем изображения)
    ///   - photo: Изображение для загрузки.
    ///   - completion: Возвращает либо ссылку на загруженное изображение в Storage для последующего сохранения в БД Firestore, либо ошибку.
    func saveImageIntoStorage(urlLink: StorageReference, photo: UIImage, completion: @escaping (Result <URL, Error>) -> Void)


    /// Функция для сохранения URL изображения из Storage в Firestore.
    /// - Parameters:
    ///   - image: URL изображения.
    ///   - user: uid текущего атворизованного пользователя.
    func saveImageIntoPhotoAlbum(image: String, user: String)


    /// Функция для загрузки изображений из Firestore.
    /// - Parameters:
    ///   - user: uid пользователя из БД.
    ///   - completion: Возвращает либо массив изображений, либо ошибку.
    func fetchImagesFromStorage(user: String, completion: @escaping (Result <[String:[UIImage]], Error>) -> Void)

    // MARK: - Функции для работы с файлами
    func saveFileIntoStorage(fileURL: URL, user: String, completion: @escaping (Result<URL, any Error>) -> Void)
}


final class FireStoreService: FireStoreServiceProtocol {

    var postListner: ListenerRegistration?

    var userListner: ListenerRegistration?

    var currentPostListner: ListenerRegistration?

    var favouritesListener: ListenerRegistration?

    static let shared = FireStoreService()

    private init() {}

    func addSnapshotListenerToUser(for user: String, completion: @escaping (Result<FirebaseUser, Error>) -> Void) {
        self.userListner?.remove()
        let ref = Firestore.firestore().collection("Users").document(user)
        self.userListner = ref.addSnapshotListener({ snapshot, error in
            if let error = error {
                completion(.failure(error))
            }

            if let snapshot = snapshot {
                do {
                    let user = try snapshot.data(as: FirebaseUser.self)
                    completion(.success(user))
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
                    completion(.failure(error))
                }
            }
        })
    }

    func removeListenerForUser() {
        self.userListner?.remove()
    }

    func addSnapshotListenerToPosts(for user: String, completion: @escaping (Result<[EachPost], Error>) -> Void) {
        self.postListner?.remove()
        let ref =  Firestore.firestore().collection("Users").document(user).collection("posts")
        var updatedArray: [EachPost] = []
        self.postListner = ref.addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
            }

            if let snapshot = snapshot {
                if snapshot.documents.isEmpty {
                    updatedArray = []
                    completion(.success(updatedArray))
                } else {
                    updatedArray = []
                    for document in snapshot.documents {
                        do {
                            let post = try  document.data(as: EachPost.self)
                            updatedArray.append(post)
                        } catch {
                            completion(.failure(error))
                        }
                    }
                    completion(.success(updatedArray))
                }
            }
        }
    }

    func addSnapshotListenerToFavourites(for user: String, completion: @escaping (Result<[EachPost], Error>) -> Void) {
        self.favouritesListener?.remove()
        let ref =  Firestore.firestore().collection("Users").document(user).collection("Favourites")
        var updatedArray: [EachPost] = []
        self.favouritesListener = ref.addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
            }

            if let snapshot = snapshot {
                if snapshot.documents.isEmpty {
                    updatedArray = []
                    completion(.success(updatedArray))
                } else {
                    updatedArray = []
                    for document in snapshot.documents {
                        do {
                            let post = try  document.data(as: EachPost.self)
                            updatedArray.append(post)
                        } catch {
                            completion(.failure(error))
                        }
                    }
                    completion(.success(updatedArray))
                }
            }
        }
    }

    func removeListenerForFavourites() {
        favouritesListener?.remove()
    }

    func removeListenerForPosts() {
        postListner?.remove()
    }

    func addSnapshotListenerToCurrentPost(docID: String, userID: String, completion: @escaping (Result<EachPost, Error>) -> Void) {
        self.currentPostListner?.remove()
        let ref =  Firestore.firestore().collection("Users").document(userID).collection("posts").document(docID)
        self.currentPostListner = ref.addSnapshotListener { docSnapshot, error in
            if let error = error {
                completion(.failure(error))
            }

            if let docSnapshot = docSnapshot {
                do {
                    let doc = try docSnapshot.data(as: EachPost.self)
                    completion(.success(doc))
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
                    completion(.failure(error))
                }
            }
        }
    }

    func removeListenerForCurrentPost() {
        self.currentPostListner?.remove()
    }

    func getAllUsers(completion: @escaping (Result<[FirebaseUser], Error>) -> Void) {
        var usersArray: [FirebaseUser] = []
        let dbReference = Firestore.firestore().collection("Users")
        dbReference.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            }
            if let snapshot = snapshot {
                do {
                    for document in snapshot.documents {
                        let currentUser = try document.data(as: FirebaseUser.self)
                        usersArray.append(currentUser)
                    }
                } catch {
                    completion(.failure(error))
                }
            }
            completion(.success(usersArray))
        }
    }

    func incrementLikesForPost(user: String, mainUser: String, post: String) {
        let date = Date.now
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        let string = dateFormatter.string(from: date)
        let like = Like(documentID: mainUser, date: string)
        let dbReference = Firestore.firestore().collection("Users").document(user).collection("posts").document(post).collection("likes").document(mainUser)
        dbReference.setData(["date" : like.date!,
                             "documentID" : like.documentID!
                            ])
    }

    func incrementLikesForAnswer(answerID: String, user: String, postID: String, commentID: String, mainUserID: String) {
        let docRef = Firestore.firestore().collection("Users").document(user).collection("posts").document(postID).collection("comments").document(commentID).collection("answers").document(answerID)
        docRef.updateData(["likes" : FieldValue.arrayUnion([mainUserID])])
    }

    func incrementLikesForComment(commentID: String, user: String, postID: String, mainUserID: String) {
        let commentRef = Firestore.firestore().collection("Users").document(user).collection("posts").document(postID).collection("comments").document(commentID)
        commentRef.updateData(["likes": FieldValue.arrayUnion([mainUserID])])
    }

    func decrementLikesForAnswer(answerID: String, user: String, postID: String, commentID: String, mainUserID: String) {
        let docRef = Firestore.firestore().collection("Users").document(user).collection("posts").document(postID).collection("comments").document(commentID).collection("answers").document(answerID)
        docRef.updateData(["likes" : FieldValue.arrayRemove([mainUserID])])
    }

    func decrementLikesForComment(commentID: String, user: String, postID: String, mainUserID: String) {
        let commentRef = Firestore.firestore().collection("Users").document(user).collection("posts").document(postID).collection("comments").document(commentID)
        commentRef.updateData(["likes" : FieldValue.arrayRemove([mainUserID])])
    }

    func decrementLikesForPost(user: String, mainUser: String, post: String) {
        let dbReference = Firestore.firestore().collection("Users").document(user).collection("posts").document(post).collection("likes").document(mainUser)
        dbReference.delete()
    }

    func getNumberOfLikesInpost(user: String, post: String, completion: @escaping (Result <[Like], Error>) -> Void) {
        let dbRef = Firestore.firestore().collection("Users").document(user).collection("posts").document(post).collection("likes")
        var likes: [Like] = []

        dbRef.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            }

            if let snapshot = snapshot {
                if !snapshot.documents.isEmpty {
                    for document in snapshot.documents {
                        do {
                            let like = try document.data(as: Like.self)
                            likes.append(like)
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
                            completion(.failure(error))
                        }
                    }
                } else {
                    completion(.success(likes))
                }
                completion(.success(likes))
            }
        }
    }

    func getUser(id: String, completion: @escaping (Result<FirebaseUser, AuthorisationErrors>) -> Void) {
        let dbReference = Firestore.firestore().collection("Users")
        dbReference.getDocuments {  snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(.failure(.invalidCredential))
                return
            }

            guard let snapshot = snapshot else {
                completion(.failure(.invalidCredential))
                return
            }

            if snapshot.documents.isEmpty {
                completion(.failure(.userAlreadyExist))
                return
            }

            for document in snapshot.documents {
                if document.documentID == id {
                    do {
                        let currentUser = try document.data(as: FirebaseUser.self)
                        completion(.success(currentUser))
                        return
                    } catch let DecodingError.dataCorrupted(context) {
                        print(context)
                    } catch let DecodingError.keyNotFound(key, context) {
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.valueNotFound(value, context) {
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.typeMismatch(type, context) {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch {
                        print("error: ", error)
                    }
                }
            }
            completion(.failure(.invalidCredential))
        }
    }

    func getPosts(sub: String, completion: @escaping (Result<[EachPost], PostErrors>) -> Void) {
        let refDB = Firestore.firestore().collection("Users").document(sub).collection("posts")
        var posts: [EachPost] = []

        refDB.getDocuments { snapshot, error in

            if error != nil {
                completion(.failure(.getError))
                return
            }

            guard let snapshot = snapshot else {
                completion(.failure(.getError))
                return
            }

            if snapshot.documents.isEmpty {
                completion(.success([]))
                return
            }

            for document in snapshot.documents {
                do {
                    let eachPost = try document.data(as: EachPost.self)
                    posts.append(eachPost)
                } catch {
                    print(error.localizedDescription)
                }
            }
            completion(.success(posts))
        }
    }

    func changeData(id: String, text: String, state: ChangeStates) {

        let ref = Firestore.firestore().collection("Users").document(id)

        switch state {
        case .name:
            ref.updateData(["name" : text])
        case .job:
            ref.updateData(["job" : text])
        case .identifier:
            ref.updateData(["identifier" : text])
        case .interests:
            ref.updateData(["interests" : text])
        case .contacts:
            ref.updateData(["contacts" : text])
        case .surname:
            ref.updateData(["surname" : text])
        case .storie:
            ref.updateData(["stories": FieldValue.arrayUnion([text])])
        case .dateOfBirth:
            ref.updateData(["dateOfBirth" : text])
        case .files:
            ref.updateData(["files" : FieldValue.arrayUnion([text])])
        }
    }

    func fetchFavourites(user: String, completion: @escaping (Result<[EachPost], Error>) -> Void) {
        let ref = Firestore.firestore().collection("Users").document(user).collection("Favourites")
        var posts: [EachPost] = []
        ref.getDocuments { snapshot, error in
            if error != nil {
                return
            }

            if let snapshot = snapshot {
                if snapshot.documents.isEmpty {
                    return
                }
                for document in snapshot.documents {
                    do {
                        let eachPost = try document.data(as: EachPost.self)
                        posts.append(eachPost)
                    }  catch let DecodingError.dataCorrupted(context) {
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
                }
            }
            completion(.success(posts))
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

    func fetchImagesFromStorage(user: String, completion: @escaping (Result<[String: [UIImage]], Error>) -> Void) {
        let link = Storage.storage().reference().child("users").child(user).child("PhotoAlbum")
        var testDictionary: [String: [UIImage]] = [:]

        link.listAll { storageList, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let storageList = storageList else {
                completion(.success(testDictionary))
                return
            }

            let dispatchGroup = DispatchGroup()

            for folder in storageList.prefixes {
                dispatchGroup.enter()

                folder.listAll { folderStorageList, error in
                    if let folderStorageList = folderStorageList {
                        for document in folderStorageList.items {
                            dispatchGroup.enter()

                            document.getData(maxSize: 1 * 2048 * 2048) { data, error in
                                defer {
                                    dispatchGroup.leave()
                                }

                                if let error = error {
                                    completion(.failure(error))
                                    return
                                }

                                if let data = data, let decodedImage = UIImage(data: data) {
                                    if var existingImages = testDictionary[folder.name] {
                                        existingImages.append(decodedImage)
                                        testDictionary[folder.name] = existingImages
                                    } else {
                                        testDictionary[folder.name] = [decodedImage]
                                    }
                                }
                            }
                        }
                    }

                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                completion(.success(testDictionary))
            }
        }
    }

    func pinPost(user: String, docID: String) {
        let reft = Firestore.firestore().collection("Users").document(user).collection("posts").document(docID)
        reft.updateData(["isPinned" : true])
    }

    func createPost(date: String, text: String, image: UIImage?, for user: String, completion: @escaping (Result<EachPost, Error>) -> Void) {
        let postRef = Firestore.firestore().collection("Users").document(user).collection("posts")
        var fireStorePost = EachPost(text: "", image: "", likes: 0, commentaries: 0, date: date, isCommentariesEnabled: true, isPinned: false, userHoldingPost: user)

        if let image = image {
            let postStorageRef = Storage.storage().reference().child("users").child(user).child("posts").child(date).child(image.description)
            saveImageIntoStorage(urlLink: postStorageRef, photo: image) {  result in
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

    func addComment(mainUser: String, text: String, documentID: String, commentor: String, completion: @escaping (Result<Comment, Error>) -> Void) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        let stringFromDate = dateFormatter.string(from: date)

        let commentRef = Firestore.firestore().collection("Users").document(mainUser).collection("posts").document(documentID).collection("comments")
        let docRef = Firestore.firestore().collection("Users").document(mainUser).collection("posts").document(documentID)

        let comment = Comment(text: text, commentor: commentor, date: stringFromDate)
        do {
            try commentRef.addDocument(from: comment)
            completion(.success(comment))
            docRef.updateData(["commentaries": FieldValue.increment(Int64(1))])
        } catch {
            print(error.localizedDescription)
            completion(.failure(error))
        }
    }


    func getComments(post: String, user: String, completion: @escaping (Result<[Comment], Error>) -> Void) {
        let docReft = Firestore.firestore().collection("Users").document(user).collection("posts").document(post).collection("comments")
        var commentsArray: [Comment] = []

        docReft.getDocuments {  snapshot, error in
            if let error = error {
                completion(.failure(error))
            }

            if let snapshot = snapshot {
                for document in snapshot.documents {
                    do {
                        let comment = try document.data(as: Comment.self)
                        commentsArray.append(comment)
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
                        completion(.failure(error))
                    }
                }
            }
            completion(.success(commentsArray))
        }
    }

    func addAnswerToComment(postID: String, user: String, commentID: String, answer: Answer, completion: @escaping (Result<Answer, Error>) -> Void) {
        let docReft = Firestore.firestore().collection("Users").document(user).collection("posts").document(postID).collection("comments").document(commentID).collection("answers")
        do {
            try docReft.addDocument(from: answer)
            completion(.success(answer))
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
            completion(.failure(error))
        }
    }

    func getAnswers(post: String, comment: String, user: String, completion: @escaping (Result<[Answer], Error>) -> Void) {
        let docReft = Firestore.firestore().collection("Users").document(user).collection("posts").document(post).collection("comments").document(comment).collection("answers")
        var answers: [Answer] = []

        docReft.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            }

            if let snapshot = snapshot {
                if !snapshot.documents.isEmpty {
                    for document in snapshot.documents {
                        do {
                            let answer = try document.data(as: Answer.self)
                            print(answer)
                            answers.append(answer)
                        }
                        catch let DecodingError.dataCorrupted(context) {
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
                            completion(.failure(error))
                        }
                    }
                    completion(.success(answers))
                }
            }
        }
    }

    func saveIntoFavourites(post: EachPost, for mainUser: String, user: String, completion: @escaping(Result<Bool, Error>) -> Void) {
        let docRef = Firestore.firestore().collection("Users").document(mainUser).collection("Favourites")
        docRef.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            }

            if let snapshot = snapshot {
                if snapshot.documents.isEmpty {
                    do {
                        try docRef.addDocument(from: post)
                    } catch {
                        print(error.localizedDescription)
                    }
                } else {
                    for document in snapshot.documents {
                        let dataText = document.data()["text"] as? String
                        if dataText == post.text {
                            completion(.success(false))
                        } else {
                            do {
                                try docRef.addDocument(from: post)
                                completion(.success(true))
                            } catch {
                                print(error.localizedDescription)
                                completion(.failure(error))
                            }
                        }
                    }
                }
            }
        }
    }

    func removeFromFavourites(user: String, post: EachPost) {
        let docRef = Firestore.firestore().collection("Users").document(user).collection("Favourites")
        docRef.getDocuments { snapshot, error in
            if error != nil {
                return
            }

            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let documentText = document.data()["text"] as? String ?? "Cannot get Value"
                    if documentText == post.text {
                        let documentRef = Firestore.firestore().collection("Users").document(user).collection("Favourites").document(document.documentID)
                        documentRef.delete()
                    }
                }
            }
        }
    }

    func disableCommentaries(id: String, user: String) {
        let docRef = Firestore.firestore().collection("Users").document(user).collection("posts").document(id)
        docRef.updateData(["isCommentariesEnabled" : false])
    }

    func getDocLink(for id: String, user: String) -> String {
        let docRef = Firestore.firestore().collection("Users").document(user).collection("posts").document(id)
        return docRef.path.description
    }

    func addDocToArchives(post: EachPost, user: String, completion: @escaping (Result<EachPost, Error>) -> Void) {
        guard let documentID = post.documentID else {
            return
        }
        let archiveRef = Firestore.firestore().collection("Users").document(user).collection("Archive")
        var newPost = post

        if let image = post.image {
            let networkService = NetworkService()
            networkService.fetchImage(string: image) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let image):
                    let storagRef = Storage.storage().reference().child("users").child(user).child("archive").child(post.date)
                    saveImageIntoStorage(urlLink: storagRef, photo: image) { [weak self] result in
                        guard self != nil else { return }
                        switch result {
                        case .success(let success):
                            newPost.image = success.absoluteString
                            self?.deleteDocument(docID: documentID, user: user) { [weak self] result in
                                guard  self != nil else { return }
                                switch result {
                                case .success(_):
                                    print("Successfully archived")
                                    do {
                                        try archiveRef.addDocument(from: newPost)
                                        completion(.success(newPost))
                                    } catch {
                                        completion(.failure(error))
                                    }
                                case .failure(let failure):
                                    completion(.failure(failure))
                                }
                            }
                        case .failure(let failure):
                            completion(.failure(failure))
                        }
                    }
                case .failure(let failure):
                    completion(.failure(failure))
                }
            }
        }

        self.deleteDocument(docID: documentID, user: user) { [weak self] result in
            guard  self != nil else { return }
            switch result {
            case .success(_):
                print("Successfully archived")
                do {
                    try archiveRef.addDocument(from: newPost)
                    completion(.success(newPost))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let failure):
                completion(.failure(failure))
            }
        }

    }

    func deleteDocument(docID: String, user: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let docRef = Firestore.firestore().collection("Users").document(user).collection("posts").document(docID)
        docRef.delete { error in
            if let error = error {
                completion(.failure(error))
            }
            print("Succesfully deleted")
            completion(.success(true))
        }
    }

    func removeSubscribtion(sub: String, for user: String) {
        let docRef = Firestore.firestore().collection("Users").document(user)
        docRef.updateData(["subscribtions" : FieldValue.arrayRemove([sub])])
        print("Successfully removed")
    }

    func removeSubscriber(sub: String, for user: String) {
        let docRef = Firestore.firestore().collection("Users").document(user)
        docRef.updateData(["subscribers" : FieldValue.arrayRemove([sub])])
        print("Successfully removed")
    }


    func fetchArchives(user: String, completion: @escaping(Result<[EachPost], Error>) -> Void) {
        var decodedDocuments: [EachPost] = []
        let link = Firestore.firestore().collection("Users").document(user).collection("Archive")
        link.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            }

            if let snapshot = snapshot {
                for document in snapshot.documents {
                    do {
                        let decodedDoc = try document.data(as: EachPost.self)
                        decodedDocuments.append(decodedDoc)
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
                        completion(.failure(error))
                    }
                }
                completion(.success(decodedDocuments))
            }
        }
    }

    func saveToBookMarks(mainUser: String, user: String, post: EachPost, completion: @escaping(Result<Bool, Error>) -> Void) {
        let link = Firestore.firestore().collection("Users").document(mainUser).collection("Bookmarks")
        link.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let snapshot = snapshot {
                if snapshot.documents.isEmpty {
                    do {
                        try link.addDocument(from: post)
                        completion(.success(true))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    for document in snapshot.documents {
                        let documentText = document.data()["text"] as? String
                        if documentText == post.text {
                            completion(.success(false))
                        } else {
                            do {
                                try link.addDocument(from: post)
                                completion(.success(true))
                            } catch {
                                completion(.failure(error))
                            }
                        }
                    }
                }
            }
        }
    }

    func fetchBookmarkedPosts(user: String, completion: @escaping (Result<[EachPost], Error>) -> Void) {
        let link = Firestore.firestore().collection("Users").document(user).collection("Bookmarks")
        var decodedDocuments: [EachPost] = []

        link.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            }

            if let snapshot = snapshot {
                for document in snapshot.documents {
                    do {
                        let decodedDoc = try document.data(as: EachPost.self)
                        decodedDocuments.append(decodedDoc)
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
                        completion(.failure(error))
                    }
                }
            }
            completion(.success(decodedDocuments))
        }
    }

    func addReportToUser(user: String, text: String) {
        let refDB = Firestore.firestore().collection("Users").document(user)
        refDB.updateData(["report" : FieldValue.arrayUnion([text])])
    }

    func saveFileIntoStorage(fileURL: URL, user: String, completion: @escaping (Result<URL, any Error>) -> Void) {
        let storageRef = Storage.storage().reference().child("users").child(user).child("Files").child(fileURL.lastPathComponent)
        storageRef.putFile(from: fileURL, metadata: nil) { metaData, error in
            if let error = error {
                completion(.failure(error))
            }

            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                }

                if let url = url {
                    completion(.success(url))
                }
            }
        }
    }
}


