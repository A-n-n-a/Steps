//
//  Endpoint.swift
//  Steps_test
//
//  Created by Anna on 9/19/21.
//

import Foundation

protocol Endpoint {
    
    var base: String { get }
    var path: String { get }
}
extension Endpoint {
    
    var request: URLRequest {
        let urlString = base + path
        let url = URL(string: urlString)!
        return URLRequest(url: url)
    }
}
