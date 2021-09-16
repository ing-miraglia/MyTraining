//
//  SceneDelegate.swift
//  Cloudy
//
//  Created by Bart Jacobs on 15/05/2020.
//  Copyright © 2020 Cocoacasts. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Properties
    
    var window: UIWindow?

    // MARK: - Scene Life Cycle

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard (scene as? UIWindowScene) != nil else {
            return
        }
        
        // Configure Window
        window?.tintColor = .primary

        guard let rootViewController = window?.rootViewController as? RootViewController else {
            fatalError()
        }
        
        // Initialize View Model
        let viewModel = RootViewModel()
        
        // Configure Root View Controller
        rootViewController.viewModel = viewModel
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    // MARK: -
    
    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}

}
