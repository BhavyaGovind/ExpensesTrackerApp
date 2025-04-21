//
//  AddExpenseViewController.swift
//  ExpensesTrackerApp
//
//  Created by Santosh Govind on 3/19/25.
//

import UIKit
import SnapKit
import Combine

class AddExpenseViewController: UIViewController, UITextFieldDelegate {

    private var viewModel: AddExpenseViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    private var amountTextField: UITextField!
    private var descriptionTextField: UITextField!
    private var saveButton: UIButton!
    
    init(viewModel: AddExpenseViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
        
        // Set delegates for text fields
        amountTextField.delegate = self
        descriptionTextField.delegate = self
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        navigationItem.title = viewModel.expense != nil ? "Edit Expense" : "Add Expense"
        
        amountTextField = UITextField()
        amountTextField.placeholder = "Amount"
        amountTextField.keyboardType = .decimalPad
        amountTextField.font = UIFont.systemFont(ofSize: 18)
        amountTextField.textColor = .black
        amountTextField.layer.borderColor = UIColor.gray.cgColor
        amountTextField.layer.borderWidth = 1.0
        amountTextField.layer.cornerRadius = 8
        amountTextField.setLeftPaddingPoints(10)
        view.addSubview(amountTextField)
        
        descriptionTextField = UITextField()
        descriptionTextField.placeholder = "Enter description"
        descriptionTextField.font = UIFont.systemFont(ofSize: 18)
        descriptionTextField.textColor = .black
        descriptionTextField.layer.borderColor = UIColor.gray.cgColor
        descriptionTextField.layer.borderWidth = 1.0
        descriptionTextField.layer.cornerRadius = 8
        descriptionTextField.setLeftPaddingPoints(10)
        view.addSubview(descriptionTextField)
        
        saveButton = UIButton(type: .system)
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.addTarget(self, action: #selector(saveExpenseTapped), for: .touchUpInside)
        view.addSubview(saveButton)
        
        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        descriptionTextField.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(20)
            make.left.right.equalTo(amountTextField)
            make.height.equalTo(50)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextField.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
    }
    
    private func setupBindings() {
        viewModel.expenseDescription
            .sink { [weak self] text in
                self?.descriptionTextField.text = text
            }
            .store(in: &cancellables)
        
        viewModel.amount
            .sink { [weak self] amount in
                guard let self = self else { return }
                let amountString = "\(amount)"
                if self.amountTextField.text != amountString {
                    self.amountTextField.text = amountString
                }
            }
            .store(in: &cancellables)
    }

    @objc private func saveExpenseTapped() {
        if let amountText = amountTextField.text, let amount = Double(amountText) {
            viewModel.amount.send(amount)
        }
        
        if let description = descriptionTextField.text {
            viewModel.expenseDescription.send(description)
        }

        if let errorMessage = viewModel.validateAndSaveExpense() {
            showAlert(errorMessage)
        }
    }
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // UITextFieldDelegate method for handling editing changes
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == amountTextField {
            // Handle amount text field when editing ends
            if let text = textField.text, let amount = Double(text) {
                viewModel.amount.send(amount)
            } else {
                viewModel.amount.send(0.0)
            }
        }
    }
    
    // UITextFieldDelegate method to control input changes
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == amountTextField {
            let currentText = textField.text ?? ""
            return viewModel.shouldAllowChange(currentText: currentText, range: range, replacementString: string)
        }
        return true
    }
}
// Helper function to add padding inside text fields
extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

