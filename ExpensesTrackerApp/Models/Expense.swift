//
//  Expense.swift
//  ExpensesTrackerApp
//
//  Created by Santosh Govind on 3/6/25.
//
import Foundation
import RealmSwift

class Expense: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var expenseDescription: String = ""
    @objc dynamic var amount: Double = 0.0
    @objc dynamic var date: Date = Date()
    
    override static func primaryKey() -> String? {
            return "id"
        }

}

