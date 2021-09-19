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
    func getComments() -> AnyPublisher<[Comment], Error>?
    func validateValues(first: String, second: String) -> NumbersValidationResult
}

class InitialViewModel: InitialViewModelProtocol {
    
    var networkService: NetworkServiceProtocol
    
    required init(dependency: InitialDependency) {
        self.networkService = dependency.networkService
    }
    
    func validateValues(first: String, second: String) -> NumbersValidationResult {
        if
            let firstInt = Int(first),
            let secondInt = Int(second) {
            return InputNumbersValidator.validateNumbers(first: firstInt, second: secondInt)
        }
        return .notNumbers
    }
    
    func getComments() -> AnyPublisher<[Comment], Error>? {
        let intArray: [Int] = Array(3...5)
        if let commentService = networkService as? CommentsService {
            return commentService.getComments(endpoint: CommentsEndpoint(ids: intArray))
        }
        return nil
    }
}
