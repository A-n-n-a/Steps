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
    
    private var viewModel: InitialViewModelProtocol?
    private var cancellables = [AnyCancellable]()
    
    private var firstValue: String = ""
    private var secondValue: String = ""
    private var requestExecuting = false {
        didSet {
            let buttonTitle = requestExecuting ? "Cancel" : "Get comments"
            button.setTitle(buttonTitle, for: .normal)
        }
    }
    
    private var animationTimer: Timer?
    
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
        button.alpha = disableButton ? 0.7 : 1
        button.isEnabled = !disableButton
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func getComments(_ sender: Any) {
        if requestExecuting {
            viewModel?.cancelRequest()
        } else {
            validateValues()
        }
    }
    
    private func validateValues() {
        let validationResult = viewModel?.validateValues(first: firstValue, second: secondValue)
        switch validationResult {
        case .valid:
            if let start = Int(firstValue), let end = Int(secondValue) {
                getComments(startValue: start, endValue: end)
            }
        default:
            showAlert(title: "Error", message: validationResult?.errorText)
        }
    }
    
    private func getComments(startValue: Int, endValue: Int) {
        showAnimation(show: true)
        viewModel?.getFirstComments(startValue: startValue, endValue: endValue)?
            .sink { [weak self] completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                self?.showAnimation(show: false)
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        } receiveValue: { [weak self] comments in
            self?.showAnimation(show: false)
        }.store(in: &cancellables)
    }
    
    private func showAnimation(show: Bool) {
        if show {
            activityIndicator.startAnimating()
            startAnimationTimer()
        } else {
            activityIndicator.stopAnimating()
        }
        blockingView.isHidden = !show
        requestExecuting = show
    }
    
    private func startAnimationTimer() {
        var animationTime = 3
        animationTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            if animationTime > 0 {
                animationTime -= 1
            } else {
                self.animationTimer?.invalidate()
                self.showAnimation(show: false)
                self.viewModel?.cancelRequest()
            }
        })
    }
}

