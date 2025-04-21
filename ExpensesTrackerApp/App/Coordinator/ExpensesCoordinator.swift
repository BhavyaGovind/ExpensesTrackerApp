//
//  ExpensesCoordinator.swift
//  ExpensesTrackerApp
//
//  Created by Santosh Govind on 3/6/25.
//

import UIKit
protocol ExpensesCoordinatorDelegate: AnyObject {
    func didSignOut()
}
class ExpensesCoordinator {
    var navigationController: UINavigationController
    var rootViewController: UIViewController!
    weak var delegate: ExpensesCoordinatorDelegate?
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = ExpensesViewModel(coordinator: self)
        rootViewController = ExpensesViewController(viewModel: viewModel)
        
        navigationController.pushViewController(rootViewController, animated: true)
    }
    
     func showAddExpenseScreen() {
        print("Displaying Add Screen")
        let addExpenseViewModel = AddExpenseViewModel(expense: nil)
        let addExpenseVC = AddExpenseViewController(viewModel: addExpenseViewModel)
        
        addExpenseViewModel.onExpenseSaved = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        
        navigationController.pushViewController(addExpenseVC, animated: true)
    }
    
     func showEditExpenseScreen(with expense:Expense? = nil) {
        
        print("Displaying EditScreen")
        let addExpenseViewModel = AddExpenseViewModel(expense: expense)
        let addExpenseVC = AddExpenseViewController(viewModel: addExpenseViewModel)
        
        addExpenseViewModel.onExpenseSaved = { [weak self] in
            self?.navigationController.popViewController(animated: true)
        }
        
        navigationController.pushViewController(addExpenseVC, animated: true)
    }
    
    func navigateToLoginScreen() {
            delegate?.didSignOut()
    }
}


