//
//  InitialViewModel.swift
//  Steps_test
//
//  Created by Anna on 9/19/21.
//

protocol Dependency {
    
}

struct InitialDependency: Dependency {
    let networkService: NetworkService
}

import Foundation

protocol InitialViewModelProtocol {
    init(dependency: InitialDependency)
}

class InitialViewModel: InitialViewModelProtocol {
    
    let networkService: NetworkService
    
    required init(dependency: InitialDependency) {
        self.networkService = dependency.networkService
    }
}
