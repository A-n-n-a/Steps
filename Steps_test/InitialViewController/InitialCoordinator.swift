//
//  InitialCoordinator.swift
//  Steps_test
//
//  Created by Anna on 9/19/21.
//

import UIKit

class InitialCoordinator: Coordinator {
    
    private let presenter: UINavigationController
    private let dependency: InitialDependency
    private var initialViewController: InitialViewController?
    
    init(presenter: UINavigationController, dependency: InitialDependency) {
        self.presenter = presenter
        self.dependency = dependency
    }
    
    func start() {
        let initialViewModel = InitialViewModel(dependency: dependency)
        let initialViewController = InitialViewController(viewModel: initialViewModel)
        self.initialViewController = initialViewController
        
        presenter.pushViewController(initialViewController, animated: true)
    }
}
