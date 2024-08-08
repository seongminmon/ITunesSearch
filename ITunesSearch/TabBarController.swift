//
//  TabBarController.swift
//  ITunesSearch
//
//  Created by 김성민 on 8/8/24.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .systemGray
        
        let today = UINavigationController(rootViewController: TodayViewController())
        today.tabBarItem = UITabBarItem(title: "투데이", image: UIImage(systemName: "book"), tag: 0)
        
        let game = UINavigationController(rootViewController: GameViewController())
        game.tabBarItem = UITabBarItem(title: "게임", image: UIImage(systemName: "gamecontroller"), tag: 1)
        
        let app = UINavigationController(rootViewController: AppViewController())
        app.tabBarItem = UITabBarItem(title: "앱", image: UIImage(systemName: "square.stack"), tag: 2)
        
        let arcade = UINavigationController(rootViewController: ArcadeViewController())
        arcade.tabBarItem = UITabBarItem(title: "아케이드", image: UIImage(systemName: "star"), tag: 3)
        
        let search = UINavigationController(rootViewController: SearchViewController())
        search.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 4)
        
        setViewControllers([today, game, app, arcade, search], animated: true)
        
        tabBar.items?.forEach { $0.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0) }
        
        // 첫 화면 검색 탭으로 설정하기
        selectedIndex = 4
    }
}
