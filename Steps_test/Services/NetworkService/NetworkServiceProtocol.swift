//
//  NetworkServiceProtocol.swift
//  Steps_test
//
//  Created by Anna on 9/19/21.
//

import Foundation
import Combine

protocol NetworkServiceProtocol {
    var session: URLSession { get }
    func execute<T>(_ request: URLRequest,
                    decodingType: T.Type,
                    queue: DispatchQueue) -> AnyPublisher<T, Error> where T: Decodable
}

extension NetworkServiceProtocol {
    
    func execute<T>(_ request: URLRequest,
                    decodingType: T.Type,
                    queue: DispatchQueue = .main) -> AnyPublisher<T, Error> where T: Decodable {
        
        return session.dataTaskPublisher(for: request)
            .tryMap {
                guard let response = $0.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw APIError.responseUnsuccessful
                }
                return $0.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: queue)
            .eraseToAnyPublisher()
    }
}
