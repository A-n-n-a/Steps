//
//  InitialCoordinator.swift
//  Steps_test
//
//  Created by Anna on 9/19/21.
//

import UIKit
import Combine

class InitialCoordinator: Coordinator {
    
    private let presenter: UINavigationController
    private let dependency: InitialDependency
    private var initialViewController: InitialViewController?
    private var cancellables = [AnyCancellable]()
    
    init(presenter: UINavigationController, dependency: InitialDependency) {
        self.presenter = presenter
        self.dependency = dependency
    }
    
    func start() {
        let initialViewModel = InitialViewModel(dependency: dependency)
        let initialViewController = InitialViewController(viewModel: initialViewModel)
        self.initialViewController = initialViewController
        
        initialViewModel.showCommentsPublisher.sink { [weak self] comments in
            if !comments.isEmpty {
                self?.showCommentsViewController(comments: comments)
            }
        }.store(in: &cancellables)
        
        presenter.pushViewController(initialViewController, animated: true)
    }
    
    private func showCommentsViewController(comments: [Comment]) {
        let commentsDependency = CommentsDependency(networkService: dependency.networkService, comments: comments)
        let commentsViewModel = CommentsViewModel(dependency: commentsDependency)
        let commentsViewController = CommentsViewController(viewModel: commentsViewModel)
        
//        initialViewController = initialViewController
        
        presenter.pushViewController(commentsViewController, animated: true)
    }
}
