//
//  AddExpenseViewModel.swift
//  ExpensesTrackerApp
//
//  Created by Santosh Govind on 3/19/25.
//

import Combine
import RealmSwift
import Foundation

class AddExpenseViewModel {
    var expense: Expense?
    var amount = CurrentValueSubject<Double, Never>(0.0)
    var expenseDescription = CurrentValueSubject<String, Never>("")
    var onExpenseSaved: (() -> Void)?


    private var cancellables = Set<AnyCancellable>()

    init(expense: Expense? = nil) {
        self.expense = expense
        if let expense = expense {
            amount.send(expense.amount)
            expenseDescription.send(expense.expenseDescription)
        }
    }
    
    func validateAndSaveExpense() -> String? {
            guard amount.value > 0 else { return "Invalid amount" }
            guard !expenseDescription.value.isEmpty else { return "Description cannot be empty" }
            
            saveExpense()
            return nil
    }

    func saveExpense() {
        if expense != nil {
            ExpenseManager.shared.updateExpense(expense!, newAmount: amount.value, newDescription: expenseDescription.value )
        } else {
            ExpenseManager.shared.createExpenses(amount: amount.value,description: expenseDescription.value)
        }
        
        onExpenseSaved?()
    }
    
    func shouldAllowChange(currentText: String, range: NSRange, replacementString string: String) -> Bool {
        if string == "." && currentText.contains(".") {
            return false
        }
        return true
    }
}


