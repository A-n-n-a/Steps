//
//  InitialViewController.swift
//  Steps_test
//
//  Created by Anna on 9/18/21.
//

import UIKit
import Combine

class InitialViewController: UIViewController {
    
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    var viewModel: InitialViewModelProtocol?
    private var cancellables = [AnyCancellable]()
    
    var firstValue: String = ""
    var secondValue: String = ""
    
    convenience init(viewModel: InitialViewModelProtocol) {
            self.init()
            self.viewModel = viewModel
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addGestures()
        trackTextFieldsInput()
        updateButtonState()
    }

    private func addGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    private func trackTextFieldsInput() {
        let firstTextFieldPublisher = NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: firstTextField)
            .map( {
                ($0.object as? UITextField)?.text
            })
            .receive(on: DispatchQueue.main)
        
        firstTextFieldPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] value in
                self?.firstValue = value ?? ""
                self?.updateButtonState()
            })
            .store(in: &cancellables)
        
        let secondTextFieldPublisher = NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: secondTextField)
            .map( {
                ($0.object as? UITextField)?.text
            })
            .receive(on: DispatchQueue.main)
        
        secondTextFieldPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] value in
                self?.secondValue = value ?? ""
                self?.updateButtonState()
            })
            .store(in: &cancellables)
    }
    
    func updateButtonState() {
        let disableButton = firstValue.isEmpty || secondValue.isEmpty
        button.alpha = disableButton ? 0.8 : 1
        button.isEnabled = !disableButton
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func getComments(_ sender: Any) {
        let validationResult = viewModel?.validateValues(first: firstValue, second: secondValue)
        switch validationResult {
        case .valid:
            getComments()
        default:
            showAlert(title: "Error", message: validationResult?.errorText)
        }
    }
    
    private func getComments() {
        viewModel?.getComments()?
            .sink { [weak self] completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        } receiveValue: { comments in
            print("===COMMENTS===", comments)
        }.store(in: &cancellables)
    }
}

