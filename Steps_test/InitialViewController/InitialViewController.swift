//
//  InitialViewController.swift
//  Steps_test
//
//  Created by Anna on 9/18/21.
//

import UIKit

class InitialViewController: UIViewController {
    
    var viewModel: InitialViewModelProtocol?
    
    convenience init(viewModel: InitialViewModelProtocol) {
            self.init()
            self.viewModel = viewModel
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addGestures()
    }

    private func addGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}

