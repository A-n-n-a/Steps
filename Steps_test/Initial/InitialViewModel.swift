//
//  InitialViewModel.swift
//  Steps_test
//
//  Created by Anna on 9/19/21.
//

import Foundation
import Combine

protocol Dependency {
    
}

struct InitialDependency: Dependency {
    let networkService: NetworkServiceProtocol
}

protocol InitialViewModelProtocol {
    init(dependency: InitialDependency)
    var networkService: NetworkServiceProtocol { get set }
    func getComments(startValue: String, endValue: String) -> AnyPublisher<[Comment], Error>?
    func validateValues(first: String, second: String) -> NumbersValidationResult
}

class InitialViewModel: InitialViewModelProtocol {
    
    var networkService: NetworkServiceProtocol
    let showCommentsSubject = CurrentValueSubject<[Comment], Never>([])
    var showCommentsPublisher: AnyPublisher<[Comment], Never> {
        return showCommentsSubject.eraseToAnyPublisher()
    }
    private var cancellables = [AnyCancellable]()
    
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
    
    func getComments(startValue: String, endValue: String) -> AnyPublisher<[Comment], Error>? {
        if let commentService = networkService as? CommentsService {
            let commentsPublisher = commentService.getComments(endpoint: CommentsEndpoint(startValue: startValue, endValue: endValue))
            commentsPublisher.sink { _ in
            } receiveValue: { [weak self] comments in
                self?.showCommentsSubject.send(comments)
            }.store(in: &cancellables)

            return commentsPublisher
        }
        return nil
    }
}
