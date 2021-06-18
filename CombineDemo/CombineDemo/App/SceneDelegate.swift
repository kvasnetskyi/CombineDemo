//
//  SceneDelegate.swift
//  CombineDemo
//
//  Created by Roman Savchenko on 30.01.2021.
//

import UIKit
import Combine

enum AppFlow {
    case auth
    case tabbar
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private var cancellables = Set<AnyCancellable>()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        setFlow(.auth)
//        setFlow(.tabbar)
//        let vc = SignUpOTPViewController()
//        window?.rootViewController = vc
//        window?.makeKeyAndVisible()
        NotificationCenter.default.publisher(for: .logout)
            .sink { [unowned self] _ in setFlow(.auth) }
            .store(in: &cancellables)
    }

    func setFlow(_ flow: AppFlow) {
        window?.rootViewController = {
            switch flow {
            case .auth: return authFlow()
            case .tabbar: return mainTabBarFlow()
            }
        }()
        window?.makeKeyAndVisible()
    }

    func authFlow() -> UIViewController {
        let signUpVC = SignUpViewController()
        signUpVC.didFinishPublisher
            .sink { [unowned self] in setFlow(.tabbar) }
            .store(in: &cancellables)
        return signUpVC
    }

    func mainTabBarFlow() -> UIViewController {
        return MainTabBarController()
    }


}

