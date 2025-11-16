//
//  MainTabBarController.swift
//  Tracker
//
//  Created by Artem Kuzmenko on 15.11.2025.
//


import UIKit

// MARK: - Tab Bar Controller
class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let trackersVC = TrackersViewController()
        let staticksVC = StatsViewController()

        // Настройка Tab Bar Item с кастомными картинками
        trackersVC.tabBarItem = UITabBarItem(title: "Трекеры",
                                             image: UIImage(named: "TabTrack"),
                                             selectedImage: UIImage(named: "TabTrack"))
        
        staticksVC.tabBarItem = UITabBarItem(title: "Статистика",
                                          image: UIImage(named: "TabStat"),
                                          selectedImage: UIImage(named: "TabStat"))

        viewControllers = [
            UINavigationController(rootViewController: trackersVC),
            UINavigationController(rootViewController: staticksVC)
        ]

        setupTabBarAppearance()
    }

    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white

        // Линия
        appearance.shadowColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)

        // Неактивное состояние
        let unselectedColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        appearance.stackedLayoutAppearance.normal.iconColor = unselectedColor
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: unselectedColor]

        // Активное состояние
        let selectedColor = UIColor(red: 55/255, green: 114/255, blue: 231/255, alpha: 1)
        appearance.stackedLayoutAppearance.selected.iconColor = selectedColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selectedColor]

        tabBar.scrollEdgeAppearance = appearance
        tabBar.standardAppearance = appearance
        
    }
}
