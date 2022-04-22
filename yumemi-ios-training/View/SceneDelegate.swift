//
//  SceneDelegate.swift
//  yumemi-ios-training
//
//  Created by Zhou Chang on 2022/04/07.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let areaWeatherListViewController = AreaWeatherListViewController(viewModel: AreaWeatherListViewModel())
        let navigationController = UINavigationController(rootViewController: areaWeatherListViewController)
//        navigationController.navigationBar.prefersLargeTitles = true
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
}

