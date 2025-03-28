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

    func saveExpense() {
        if let existingExpense = expense {
//            existingExpense.amount = amount.value
//            existingExpense.expenseDescription = expenseDescription.value
            ExpenseManager.shared.updateExpense(expense!, newAmount: amount.value, newDescription: expenseDescription.value )
        } else {
            ExpenseManager.shared.createExpenses(amount: amount.value,description: expenseDescription.value)
        }
        
        onExpenseSaved?()
    }
}


