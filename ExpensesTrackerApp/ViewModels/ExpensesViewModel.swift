//
//  ExpensesViewModel.swift
//  ExpensesTrackerApp
//
//  Created by Santosh Govind on 3/6/25.
//

import Combine
import RealmSwift
import Foundation

class ExpensesViewModel {
    
    private var cancellables = Set<AnyCancellable>()
    @Published var expenses: [Expense] = []
    var coordinator:ExpensesCoordinator?
    private let authService: AuthServiceProtocol
    
    init(coordinator: ExpensesCoordinator?, authService: AuthServiceProtocol = AuthService.shared) {
        self.coordinator = coordinator
        self.authService = authService
        bindExpenseUpdates()
        fetchExpenses()
    }
    
    
    private func bindExpenseUpdates() {
        ExpenseManager.shared.expensesPublisher
            .sink{[weak self] expenses in
                dump(expenses)
                self?.expenses = expenses
            }
            .store(in: &cancellables)
    }
    func fetchExpenses() {
        //This will load the expenses only in dev mode.
        if (ProcessInfo.processInfo.environment["UITest"] != "1"){
            expenses = ExpenseManager.shared.getExpenses()
        }
        
    }
    func addExpenseTapped() {
        coordinator?.showAddExpenseScreen()
    }
    
    func editExpenseTapped(expense: Expense) {
        coordinator?.showEditExpenseScreen(with: expense)
    }
    
    func logout() {
        authService.signOut { [weak self] success, error in
            if success {
                DispatchQueue.main.async {
                    self?.coordinator?.navigateToLoginScreen()
                }
            } else {
                print("Sign-out error: \(error ?? "Unknown error")")
            }
        }
        
    }
    
    
}
