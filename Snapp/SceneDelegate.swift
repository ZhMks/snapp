//
//  SceneDelegate.swift
//  Snapp
//
//  Created by Максим Жуин on 01.04.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)

        let controller = FirstBoardingVC()
        let presenter = FirstOnBoardingPresenter(view: controller)
        controller.presener = presenter

        let navigationController = UINavigationController(rootViewController: controller)
        window.rootViewController = navigationController

        window.makeKeyAndVisible()

        self.window = window
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
    }

    func setTabBarController(_ vc: UIViewController, user: FirebaseUser, mainUserID: String) {

        guard let window = self.window else {
            return
        }

        let favouritesVC = FavouritesViewController()
        let favouritesPresenter = FavouritesPresenter(view: favouritesVC, user: user)
        favouritesVC.presenter = favouritesPresenter
        let favouriteNavVC = UINavigationController(rootViewController: favouritesVC)
        favouriteNavVC.tabBarItem = UITabBarItem(title: .localized(string: "Сохраненные"), image: UIImage(systemName: "heart"), tag: 3)

        let feedVC = FeedViewController()
        let feedPresenter = FeedPresenter(view: feedVC, user: user, mainUser: mainUserID)
        feedVC.presenter = feedPresenter
        let feedNavVc = UINavigationController(rootViewController: feedVC)
        feedNavVc.tabBarItem = UITabBarItem(title: .localized(string: "Главная"), image: UIImage(systemName: "house"), tag: 0)

        let profileNavVC = UINavigationController(rootViewController: vc)
        profileNavVC.tabBarItem = UITabBarItem(title: .localized(string: "Профиль"), image: UIImage(systemName: "person.crop.circle"), tag: 1)

        let searchVC = SearchViewController()
        let searchPresenter = SearchPresenter(view: searchVC, mainUser: mainUserID)
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

    func changeRootViewController(_ vc: UIViewController) {
        guard let window = self.window else {
            return
        }
        let uiNavigatioNController = UINavigationController(rootViewController: vc)
        window.rootViewController = uiNavigatioNController
    }

}

