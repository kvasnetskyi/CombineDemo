//
//  MainTabBarController.swift
//  CombineDemo
//
//  Created by Roman Savchenko on 31.01.2021.
//

import UIKit
import SwiftUI

class MainTabBarController: UITabBarController {

    let settingsService: SettingsService = SettingsServiceImpl()
    let postService: PostService = PostServiceImpl()

    private lazy var postsViewModel = PostsListViewModel(postService: postService, settingsService: settingsService)
    private lazy var settingsViewModel = SettingsViewModel(settingsService: settingsService)

    private lazy var postsVC = UINavigationController(rootViewController: PostsListViewController(viewModel: postsViewModel))
    private lazy var postListVC = UIHostingController(rootView: PostListView(viewModel: postsViewModel))
    private lazy var settingsVC = UINavigationController(rootViewController: SettingsViewController(viewModel: settingsViewModel))

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [postsVC, postListVC, settingsVC]

        postsVC.tabBarItem = .init(title: "UIKit", image: UIImage.init(systemName: "square"), tag: 0)
        postListVC.tabBarItem = .init(title: "Swift UI", image: UIImage.init(systemName: "square"), tag: 1)
        settingsVC.tabBarItem = .init(title: "Settings", image: UIImage.init(systemName: "square"), tag: 2)
    }

}
