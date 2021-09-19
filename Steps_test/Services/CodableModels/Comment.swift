//
//  Comment.swift
//  Steps_test
//
//  Created by Anna on 9/19/21.
//

import Foundation

struct Comment: Codable {
    let postId: Int
    let id: Int
    let name: String
    let email: String
    let body: String
}
