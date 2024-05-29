//
//  SceneDelegate.swift
//  Snapp
//
//  Created by Максим Жуин on 01.04.2024.
//

import UIKit
import FirebaseCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)

    
//        let fireUser = FirebaseUser(name: "King", surname: "PunchMan", identifier: "KingsPuch", job: "Hero", subscribers: ["Sub1", "Sub2"], subscribtions: ["Sub3", "Sub4"], stories: ["Stories1", "Stories2"], image: "https://firebasestorage.googleapis.com:443/v0/b/snappproject-9ca98.appspot.com/o/users%2FQu7irRWg3jN83xac8ZBTtwBy8EF2%2Favatar?alt=media&token=b01ca331-d32f-46fd-b603-cbc9591c5785")
//        let firestoreService = FireStoreService()
//        let userID = "uuptdvnyBrcXwovEv3U69uxMD7m1"
//        let image = UIImage(systemName: "checkmark")!
//        let posts: [MainPost] = []
//        let docID = "Qu7irRWg3jN83xac8ZBTtwBy8EF2"
//
//        let profileVC = ProfileViewController()
//        let profilePresenter = ProfilePresenter(view: profileVC, mainUser: fireUser, userID: docID, firestoreService: firestoreService)
//        profileVC.presenter = profilePresenter

        let controller = FirstBoardingVC()
        let presenter = Presenter(view: controller)
        controller.presener = presenter

        let navigationController = UINavigationController(rootViewController: controller)
        window.rootViewController = navigationController

        window.makeKeyAndVisible()

        self.window = window
        FirebaseApp.configure()

    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

    func changeRootViewController(_ vc: UIViewController, user: FirebaseUser) {

        let fireStoreService = FireStoreService()

        guard let window = self.window else {
            return
        }

        let favouritesVC = FavouritesViewController()
        let favouritesPresenter = FavouritesPresenter(view: favouritesVC, user: user, firestoreService: fireStoreService)
        favouritesVC.presenter = favouritesPresenter
        let favouriteNavVC = UINavigationController(rootViewController: favouritesVC)
        favouriteNavVC.tabBarItem = UITabBarItem(title: .localized(string: "Сохраненные"), image: UIImage(systemName: "heart"), tag: 3)

        let feedVC = FeedViewController()
        let feedPresenter = FeedPresenter(view: feedVC, user: user, firestoreService: fireStoreService)
        feedVC.presenter = feedPresenter
        let feedNavVc = UINavigationController(rootViewController: feedVC)
        feedNavVc.tabBarItem = UITabBarItem(title: .localized(string: "Главная"), image: UIImage(systemName: "house"), tag: 0)

        let profileNavVC = UINavigationController(rootViewController: vc)
        profileNavVC.tabBarItem = UITabBarItem(title: .localized(string: "Профиль"), image: UIImage(systemName: "person.crop.circle"), tag: 1)

        let searchVC = SearchViewController()
        let searchPresenter = SearchPresenter(view: searchVC, firestoreService: fireStoreService)
        searchVC.presenter = searchPresenter
        let searchNavVC = UINavigationController(rootViewController: searchVC)
        searchNavVC.tabBarItem = UITabBarItem(title: .localized(string: "Поиск"), image: UIImage(systemName: "magnifyingglass"), tag: 2)

        let tabBarController = UITabBarController()

        let viewControllers = [feedNavVc, profileNavVC, searchNavVC, favouriteNavVC]
        tabBarController.setViewControllers(viewControllers, animated: true)
        tabBarController.selectedIndex = 1
        tabBarController.tabBar.tintColor = .systemOrange

        window.rootViewController = tabBarController
    }

}

