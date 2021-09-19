//
//  AppCoordinator.swift
//  Steps_test
//
//  Created by Anna on 9/19/21.
//

import UIKit

protocol Coordinator {
     
    func start()
}

class AppCoordinator: Coordinator {
    
    private let window: UIWindow
    private let rootViewController: UINavigationController
    private var initialCoordinator: InitialCoordinator?
    
    init(window: UIWindow) {
        self.window = window
        rootViewController = UINavigationController()
        rootViewController.setNavigationBarHidden(true, animated: false)
        
        let networkService = CommentsService()
        let dependency = InitialDependency(networkService: networkService)
        initialCoordinator = InitialCoordinator(presenter: rootViewController, dependency: dependency)
    }
    
    func start() {
        window.rootViewController = rootViewController
        initialCoordinator?.start()
        window.makeKeyAndVisible()
    }
    
}
