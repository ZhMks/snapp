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
//
//        let profileVC = ProfileViewController()
//        let firebaseUser = FirebaseUser(name: "Yeji", surname: "Hwang", identifier: "YezyIzHere", job: "ITZY", subscribers: ["Sub1", "Sub2"], subscribtions: ["Subscibtion1", "Subscribtion2"], stories: ["Storie2", "Storie1"], image: "https://firebasestorage.googleapis.com:443/v0/b/snappproject-9ca98.appspot.com/o/users%2FYezyizhere%2Favatar?alt=media&token=c9353e2f-2d07-4e02-8ea6-3e66928c101e"
//)
//        let firestoreService = FireStoreService()
//        let profilePresenter = ProfilePresenter(view: profileVC, mainUser: firebaseUser, firestoreService: firestoreService)
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
        let favouritesPresenter = FavouritesPresenter(view: favouritesVC, user: user)
        favouritesVC.presenter = favouritesPresenter
        let favouriteNavVC = UINavigationController(rootViewController: favouritesVC)
        favouriteNavVC.tabBarItem = UITabBarItem(title: "Сохраненные", image: UIImage(systemName: "heart"), tag: 3)

        let feedVC = FeedViewController()
        let feedPresenter = FeedPresenter(view: feedVC, user: user)
        feedVC.presenter = feedPresenter
        let feedNavVc = UINavigationController(rootViewController: feedVC)
        feedNavVc.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(systemName: "house"), tag: 0)

        let profileNavVC = UINavigationController(rootViewController: vc)
        profileNavVC.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person.crop.circle"), tag: 1)

        let searchVC = SearchViewController()
        let searchPresenter = SearchPresenter(view: searchVC, firestoreService: fireStoreService)
        searchVC.presenter = searchPresenter
        let searchNavVC = UINavigationController(rootViewController: searchVC)
        searchNavVC.tabBarItem = UITabBarItem(title: "Поиск", image: UIImage(systemName: "magnifyingglass"), tag: 2)

        let tabBarController = UITabBarController()

        let viewControllers = [feedNavVc, profileNavVC, searchNavVC, favouriteNavVC]
        tabBarController.setViewControllers(viewControllers, animated: true)
        tabBarController.selectedIndex = 1
        tabBarController.tabBar.tintColor = .systemOrange

        window.rootViewController = tabBarController
    }

}

