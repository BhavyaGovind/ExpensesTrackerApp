//
//  ExpenseViewControllerUITests.swift
//  ExpensesTrackerAppUITests
//
//  Created by Santosh Govind on 3/29/25.
//

import XCTest

final class ExpenseViewControllerUITests: XCTestCase {
    var app:XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
            }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testExpensesScreenAppears() {
        app = XCUIApplication()
        app.launchEnvironment["UITest"] = "1"
        app.launchArguments.append("--reset-data")
        app.launch()

        XCTAssertTrue(app.navigationBars["Expenses"].exists, "Expenses screen should appear")
    }
    
    func testAddExpenseButtonExists() {
        app = XCUIApplication()
        app.launchEnvironment["UITest"] = "1"
        app.launchArguments.append("--reset-data")
        app.launch()

        let addButton = app.buttons["addExpenseButton"]
        XCTAssertTrue(addButton.exists, "Add button should be visible in the navigation bar")
        addButton.tap()
        XCTAssertTrue(app.navigationBars["Add Expense"].exists, "Add Expense screen should appear")
    }
    
    func addExpenses() {
        app = XCUIApplication()
        app.launchEnvironment["UITest"] = "1"
        app.launchArguments.append("--reset-data")
        app.launchArguments.append("--seed-mock-expenses")
        app.launch()
    }
    
    func testMockExpenseAppear() {
        addExpenses()
        let groceryCell = app.staticTexts["Groceries"]
        let transportCell = app.staticTexts["Transport"]
        XCTAssertTrue(groceryCell.exists, "Groceries expense should apprear")
        XCTAssertTrue(transportCell.exists, "Transport expense should apprear")
    }
    
    func testTappingExpenseNavigatesToEditScreen() {
        addExpenses()
        let firstExpense = app.tables.cells.element(boundBy: 0)
        firstExpense.tap()
        XCTAssertTrue(app.navigationBars["Edit Expense"].exists, "Should navigate to Edit expense screen")
    }
}
