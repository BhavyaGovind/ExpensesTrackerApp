//
//  ExpensesViewModel.swift
//  ExpensesTrackerApp
//
//  Created by Santosh Govind on 3/6/25.
//

import Combine
import RealmSwift

class ExpensesViewModel {
    
    private var cancellables = Set<AnyCancellable>()
    @Published var expenses: [Expense] = []
    var coordinator:ExpensesCoordinator?
    
    init(coordinator: ExpensesCoordinator?) {
        self.coordinator = coordinator
        bindExpenseUpdates()
        fetchExpenses()
    }
    
    
    private func bindExpenseUpdates() {
        ExpenseManager.shared.expensesPublisher
            .sink{[weak self] expenses in
                self?.expenses = expenses
            }
            .store(in: &cancellables)
    }
    func fetchExpenses() {
        expenses = ExpenseManager.shared.getExpenses()
    }
    func addExpenseTapped() {
        coordinator?.showAddExpenseScreen()
    }
    
    func editExpenseTapped(expense: Expense) {
        coordinator?.showEditExpenseScreen(with: expense)
    }
    
}
