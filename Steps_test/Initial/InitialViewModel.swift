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
    func getFirstComments(startValue: Int, endValue: Int) -> AnyPublisher<[Comment], Error>?
    func validateValues(first: String, second: String) -> NumbersValidationResult
}

class InitialViewModel: InitialViewModelProtocol {
    
    var networkService: NetworkServiceProtocol
    let showCommentsSubject = CurrentValueSubject<([Comment], Int, Int), Never>(([], 0, 0))
    var showCommentsPublisher: AnyPublisher<([Comment], Int, Int), Never> {
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
    
    func getFirstComments(startValue: Int, endValue: Int) -> AnyPublisher<[Comment], Error>? {
        var end = endValue
        let offset = startValue + 10
        if endValue > offset {
            end = offset
        }
        if let commentService = networkService as? CommentsService {
            let commentsPublisher = commentService.getComments(endpoint: CommentsEndpoint(startValue: startValue, endValue: end))
            commentsPublisher.sink { _ in
            } receiveValue: { [weak self] comments in
                self?.showCommentsSubject.send((comments, offset, endValue))
            }.store(in: &cancellables)

            return commentsPublisher
        }
        return nil
    }
}
