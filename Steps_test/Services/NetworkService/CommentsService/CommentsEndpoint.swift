//
//  CommentsEndpoint.swift
//  Steps_test
//
//  Created by Anna on 9/19/21.
//

import Foundation

struct CommentsEndpoint: Endpoint {
    
    private let startValue: Int
    private let endValue: Int
    
    init(startValue: Int, endValue: Int) {
        self.startValue = startValue
        self.endValue = endValue
    }
    
    var base: String {
        return "https://jsonplaceholder.typicode.com"
    }
    
    var path: String {
        var path = "/comments"
        path.append("?_sort=id&_order=asc&&_start=\(startValue)&_end=\(endValue)")
        return path
    }
}
