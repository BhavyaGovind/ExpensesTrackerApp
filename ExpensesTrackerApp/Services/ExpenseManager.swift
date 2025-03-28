//
//  DataManager.swift
//  ExpensesTrackerApp
//
//  Created by Santosh Govind on 3/19/25.
//

import Foundation
import RealmSwift
import Combine

class ExpenseManager {
    static let shared = ExpenseManager()
    private var realm: Realm
    private var expensesSubject = PassthroughSubject<[Expense], Never>()
    
    
    var expensesPublisher: AnyPublisher<[Expense], Never> {
        return expensesSubject.eraseToAnyPublisher()
    }
    
    private init() {
        realm = try! Realm()
    }
    func getExpenses() -> [Expense] {
        let expenses = realm.objects(Expense.self)
        return Array(expenses)
    }
    
    func createExpenses(amount: Double, description: String) {
        let expense = Expense()
        expense.amount = amount
        expense.expenseDescription = description
        expense.date = Date()
        
        try! realm.write {
            realm.add(expense)
        }
        
        notifyChanges()
    }
    
    func updateExpense(_ expense: Expense, newAmount: Double, newDescription: String ) {
        guard let realmExpense = realm.object(ofType: Expense.self, forPrimaryKey: expense.id) else {
            print("Expense not found in the database")
            return
        }
        
        do {
            try realm.write {
                realmExpense.amount = newAmount
                realmExpense.expenseDescription = newDescription
                realmExpense.date = Date()
            }
            notifyChanges()
        } catch let error {
            print("Failed to update expense: \(error.localizedDescription)")
        }
    }
    
    private func notifyChanges() {
        let updatedExpenses = getExpenses()
        expensesSubject.send(updatedExpenses)
    }
}
