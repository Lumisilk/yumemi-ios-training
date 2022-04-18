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
        window.rootViewController = EmptyViewController()
        self.window = window
        window.makeKeyAndVisible()
    }
}

