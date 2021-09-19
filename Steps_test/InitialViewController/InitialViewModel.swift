//
//  InitialViewModel.swift
//  Steps_test
//
//  Created by Anna on 9/19/21.
//

protocol Dependency {
    
}

struct InitialDependency: Dependency {
    let networkService: NetworkServiceProtocol
}

import Foundation
import Combine

protocol InitialViewModelProtocol {
    init(dependency: InitialDependency)
    var networkService: NetworkServiceProtocol { get set }
}

class InitialViewModel: InitialViewModelProtocol {
    
    private var cancellable = [AnyCancellable]()
    
    var networkService: NetworkServiceProtocol
    
    required init(dependency: InitialDependency) {
        self.networkService = dependency.networkService
        
        let intArray: [Int] = Array(3...5)
        if let commentService = networkService as? CommentsService {
            commentService.getComments(endpoint: CommentsEndpoint(ids: intArray)).sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("===ERROR===", error)
                }
            } receiveValue: { comments in
                print("===COMMENTS===", comments)
            }.store(in: &cancellable)
        }
    }
}
