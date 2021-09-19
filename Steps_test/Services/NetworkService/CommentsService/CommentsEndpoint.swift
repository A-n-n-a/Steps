//
//  CommentsEndpoint.swift
//  Steps_test
//
//  Created by Anna on 9/19/21.
//

import Foundation

struct CommentsEndpoint: Endpoint {
    
    private let ids: [Int]
    
    init(ids: [Int]) {
        self.ids = ids
    }
    
    var base: String {
        return "https://jsonplaceholder.typicode.com"
    }
    
    var path: String {
        var path = "/comments"
        path.append("?id=")
        path.append(ids.map({ "\($0)"}).joined(separator: "&id="))
        print("PATH", path)
        return path
    }
}
