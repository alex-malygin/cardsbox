//
//  SceneDelegate.swift
//  CardsBox
//
//  Created by Alexander Malygin on 5/10/22.
//

import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window.windowScene = windowScene
        appCoordinator = AppCoordinator(window)
        appCoordinator?.start()
        self.window = window
    }
}
