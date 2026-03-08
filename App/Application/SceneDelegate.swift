//
//  SceneDelegate.swift
//  App
//
//  Created by Oleh Kudinov on 08.03.26.
//

import UIKit
import MoviesSearch

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var appFlowCoordinator: AppFlowCoordinator?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()

        window.rootViewController = navigationController

        let appDIContainer = (UIApplication.shared.delegate as? AppDelegate)?.appDIContainer ?? AppDIContainer()
        appFlowCoordinator = AppFlowCoordinator(navigationController: navigationController,
                                                appDIContainer: appDIContainer)
        appFlowCoordinator?.start()

        self.window = window
        window.makeKeyAndVisible()
    }
}
