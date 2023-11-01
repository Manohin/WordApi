//
//  TabBarController.swift
//  WordApi
//
//  Created by Alexey Manokhin on 31.10.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        let wordDayViewController = WordDayViewController()
        let wordsTableViewController = WordsTableViewController()
        
        let wordDayTab = UINavigationController(rootViewController: wordDayViewController)
        let wordsTab = UINavigationController(rootViewController: wordsTableViewController)
        
        wordDayTab.tabBarItem = UITabBarItem(
            title: "Слово дня",
            image: UIImage(systemName: "w.circle"),
            tag: 0
        )
        wordsTab.tabBarItem = UITabBarItem(
            title: "Список слов",
            image: UIImage(systemName: "book.circle"),
            tag: 1
        )
        
        
        self.viewControllers = [wordDayTab, wordsTab]
        self.tabBar.backgroundColor = #colorLiteral(red: 0.9446846843, green: 0.9776129127, blue: 0.9872179627, alpha: 1)
        self.tabBar.tintColor = #colorLiteral(red: 0.3538226783, green: 0.5200884938, blue: 0.5973373055, alpha: 1)
    }
}
