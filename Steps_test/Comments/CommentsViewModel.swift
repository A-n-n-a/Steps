//
//  CommentsViewModel.swift
//  Steps_test
//
//  Created by Anna on 9/19/21.
//
import Foundation
import Combine

struct CommentsDependency: Dependency {
    let networkService: NetworkServiceProtocol
    var comments: [Comment]
    let startValue: Int
    let endValue: Int
}

protocol CommentsViewModelProtocol {
    init(dependency: CommentsDependency)
    var commentsDataSourcePublisher: AnyPublisher<[Comment], Never> { get }
    var startValue: Int { get set }
    var endValue: Int { get set }
    func getNextPage()
}

class CommentsViewModel: CommentsViewModelProtocol {

    var networkService: NetworkServiceProtocol
    var comments: [Comment] {
        didSet {
            commentsDataSourceSubject.send(comments)
        }
    }
    var startValue: Int
    var endValue: Int
    
    let commentsDataSourceSubject = CurrentValueSubject<[Comment], Never>([])
    var commentsDataSourcePublisher: AnyPublisher<[Comment], Never> {
        return commentsDataSourceSubject.eraseToAnyPublisher()
    }
    
    private var cancellables = [AnyCancellable]()
    
    required init(dependency: CommentsDependency) {
        self.networkService = dependency.networkService
        self.comments = dependency.comments
        commentsDataSourceSubject.send(comments)
        self.startValue = dependency.startValue
        self.endValue = dependency.endValue
    }
    
    private func getValues() -> (Int, Int) {
        var end = endValue
        let offset = startValue + 10
        if endValue > offset {
            end = offset
        }
        return (startValue, end)
    }
    
    func getNextPage() {
        let values = getValues()
        guard let commentService = networkService as? CommentsService  else { return }
        commentService.getComments(endpoint: CommentsEndpoint(startValue: values.0, endValue: values.1))
            .sink { _ in
            } receiveValue: { [weak self] comments in
                self?.startValue = values.1
                self?.comments.append(contentsOf: comments)
            }.store(in: &cancellables)
    }
}
