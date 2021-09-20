//
//  CommentTableViewCell.swift
//  Steps_test
//
//  Created by Anna on 9/20/21.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    var comment: Comment! {
        didSet {
            idLabel.text = String(comment.id)
            nameLabel.text = comment.name
            commentLabel.text = comment.body
        }
    }
}
