//
//  AddExpenseViewController.swift
//  ExpensesTrackerApp
//
//  Created by Santosh Govind on 3/19/25.
//

import UIKit
import SnapKit
import Combine

class AddExpenseViewController: UIViewController {
    
    private var viewModel: AddExpenseViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    private var amountTextField: UITextField!
    private var descriptionTextField: UITextField!
    private var saveButton: UIButton!
    
    init(viewModel: AddExpenseViewModel) {
        self.viewModel = viewModel
        super.init(nibName:nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "Add Expense"
        
        amountTextField = UITextField()
        amountTextField.placeholder = "Amount"
        amountTextField.keyboardType = .decimalPad
        view.addSubview(amountTextField)
        
        descriptionTextField = UITextField()
        descriptionTextField.placeholder = "enter description"
        view.addSubview(descriptionTextField)
        
        saveButton = UIButton(type: .system)
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveExpeseTapped), for: .touchUpInside)
        view.addSubview(saveButton)
        
        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        descriptionTextField.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(20)
            make.left.right.equalTo(amountTextField)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        
        viewModel.expenseDescription
                    .sink { [weak self] text in
                        self?.descriptionTextField.text = text
                    }
                    .store(in: &cancellables)

                // Bind the amount text field to the ViewModel's amount property
                viewModel.amount
                    .sink { [weak self] amount in
                        self?.amountTextField.text = amount.description
                    }
                    .store(in: &cancellables)

            // Bind text fields to the view model using Combine
            amountTextField.textPublisher
                .compactMap { $0 }
                .map{ Double($0)}
                .sink { [weak self] doubleValue in
                            if let amount = doubleValue {
                                self?.viewModel.amount.send(amount)
                            } else {
                                // Handle invalid input (e.g., show an alert, log an error, etc.)
                                print("Invalid amount input")
                            }
                        }
                        .store(in: &cancellables)
            
            descriptionTextField.textPublisher
            .compactMap{ $0 }
            .sink(receiveValue: { [weak self] text in
                self?.viewModel.expenseDescription.send(text)
            })
                .store(in: &cancellables)
        }

        @objc private func saveExpeseTapped() {
//            guard let amountText = amountTextField.text, let amount = Double(amountText),
//                  let description = descriptionTextField.text else { return }

            // Delegate saving to the view model
            viewModel.saveExpense()
            
        }
    
}
