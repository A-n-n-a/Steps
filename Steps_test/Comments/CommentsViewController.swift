//
//  CommentsViewController.swift
//  Steps_test
//
//  Created by Anna on 9/18/21.
//

import UIKit
import Combine

class CommentsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: CommentsViewModelProtocol?
    private var cancellables = [AnyCancellable]()
    private let cellId = "CommentTableViewCell"
    
    convenience init(viewModel: CommentsViewModelProtocol) {
            self.init()
            self.viewModel = viewModel
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.commentsDataSource.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommentTableViewCell
        if let comment = viewModel?.commentsDataSource[indexPath.row] {
            cell.comment = comment
        }
        return cell
    }
}
