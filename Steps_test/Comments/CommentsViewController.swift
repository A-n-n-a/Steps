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
    private var commentsDataSource = [Comment]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    convenience init(viewModel: CommentsViewModelProtocol) {
            self.init()
            self.viewModel = viewModel
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
        setUpSubscriptions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setUpSubscriptions() {
        viewModel?.commentsDataSourcePublisher.sink(receiveValue: { [weak self] comments in
            self?.commentsDataSource = comments
        }).store(in: &cancellables)
    }
}

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CommentTableViewCell
        cell.comment = commentsDataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if
            commentsDataSource[indexPath.row].id == viewModel?.startValue,
            commentsDataSource[indexPath.row].id != viewModel?.endValue
            {
            viewModel?.getNextPage()
        }
    }
}
