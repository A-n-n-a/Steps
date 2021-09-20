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
    @IBOutlet weak var blockingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
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
        showAnimation(show: true)
        let validationResult = viewModel?.validateValues(first: firstValue, second: secondValue)
        switch validationResult {
        case .valid:
            getComments(startValue: firstValue, endValue: secondValue)
        default:
            showAnimation(show: false)
            showAlert(title: "Error", message: validationResult?.errorText)
        }
    }
    
    private func getComments(startValue: String, endValue: String) {
        viewModel?.getComments(startValue: startValue, endValue: endValue)?
            .sink { [weak self] completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self?.showAnimation(show: false)
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        } receiveValue: { [weak self] comments in
            print("===COMMENTS===", comments.map({ $0.id }))
            self?.showAnimation(show: false)
        }.store(in: &cancellables)
    }
    
    private func showAnimation(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        blockingView.isHidden = !show
    }
}

