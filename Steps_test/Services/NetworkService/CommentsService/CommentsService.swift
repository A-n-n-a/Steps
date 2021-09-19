//
//  CommentsService.swift
//  Steps_test
//
//  Created by Anna on 9/19/21.
//

import Foundation
import Combine

final class CommentsService: NetworkServiceProtocol {
    
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    func getComments(endpoint: CommentsEndpoint) -> AnyPublisher<[Comment], Error> {
        execute(endpoint.request, decodingType: [Comment].self)
    }
}
