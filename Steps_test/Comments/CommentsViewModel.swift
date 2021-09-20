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
}

protocol CommentsViewModelProtocol {
    init(dependency: CommentsDependency)
    var networkService: NetworkServiceProtocol { get set }
    var commentsDataSource: [Comment] { get }
    func getComments(startValue: String, endValue: String) -> AnyPublisher<[Comment], Error>?
}

class CommentsViewModel: CommentsViewModelProtocol {

    var networkService: NetworkServiceProtocol
    var comments: [Comment]
    
    var commentsDataSource: [Comment] {
        return comments
    }
    
    required init(dependency: CommentsDependency) {
        self.networkService = dependency.networkService
        self.comments = dependency.comments
    }
    
    func getComments(startValue: String, endValue: String) -> AnyPublisher<[Comment], Error>? {
        if let commentService = networkService as? CommentsService {
            return commentService.getComments(endpoint: CommentsEndpoint(startValue: startValue, endValue: endValue))
        }
        return nil
    }
}
