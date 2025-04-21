//
//  AddExpenseViewControllerUITests.swift
//  ExpensesTrackerAppUITests
//
//  Created by Santosh Govind on 3/29/25.
//

import XCTest

import XCTest

final class AddExpenseViewControllerUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchEnvironment["UITest"] = "1"
        app.launchArguments.append("--reset-data")
        app.launch()
        openAddExpenseScreen()
    }
    func openAddExpenseScreen() {
        let addButton = app.buttons["addExpenseButton"]
        addButton.tap()
    }
    override func tearDown() {
        app = nil
        super.tearDown()
    }

    // Check UI Elements Exist
    func testUIElementsExist() {
        let amountTextField = app.textFields["Amount"]
        let descriptionTextField = app.textFields["Enter description"]
        let saveButton = app.buttons["Save"]

        XCTAssertTrue(amountTextField.exists, "Amount text field should exist")
        XCTAssertTrue(descriptionTextField.exists, "Description text field should exist")
        XCTAssertTrue(saveButton.exists, "Save button should exist")
    }
    
    
    func clearAndEnterText(_ element: XCUIElement, text:String) {
        element.tap()
        if let stringValue = element.value as? String {
            let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
            element.typeText(deleteString)
        }
        element.typeText(text)
    }

    // Valid Input - Should Save Expense
    func testValidExpenseSave() {
        let amountTextField = app.textFields["Amount"]
        let descriptionTextField = app.textFields["Enter description"]
        let saveButton = app.buttons["Save"]

        
        clearAndEnterText(amountTextField, text: "50")

        descriptionTextField.tap()
        descriptionTextField.typeText("Lunch")

        saveButton.tap()

        // Verify success by checking for absence of error alert
        XCTAssertFalse(app.alerts.element.exists, "There should be no error alerts")
    }

    // Invalid Amount - Shows Error
    func testInvalidAmountShowsError() {
        let amountTextField = app.textFields["Amount"]
        let descriptionTextField = app.textFields["Enter description"]
        let saveButton = app.buttons["Save"]

        clearAndEnterText(amountTextField, text: "0")

        descriptionTextField.tap()
        descriptionTextField.typeText("Lunch")

        saveButton.tap()

        let alert = app.alerts["Error"]
        XCTAssertTrue(alert.exists, "Error alert should be shown")
        
        XCTAssertEqual(alert.staticTexts.element(boundBy: 1).label
, "Invalid amount")

        alert.buttons["OK"].tap() // Dismiss alert
    }

    // Empty Description - Shows Error
    func testEmptyDescriptionShowsError() {
        let amountTextField = app.textFields["Amount"]
        let saveButton = app.buttons["Save"]

        clearAndEnterText(amountTextField, text: "50")

        saveButton.tap()

        let alert = app.alerts["Error"]
        XCTAssertTrue(alert.exists, "Error alert should be shown")
        XCTAssertEqual(alert.staticTexts.element(boundBy: 1).label, "Description cannot be empty")

        alert.buttons["OK"].tap() // Dismiss alert
    }

    // Prevent Multiple Decimal Points
    func testPreventMultipleDecimals() {
        let amountTextField = app.textFields["Amount"]

        clearAndEnterText(amountTextField, text: "12.3")
        
        amountTextField.typeText(".")

        XCTAssertEqual(amountTextField.value as! String, "12.3", "Should not allow multiple decimal points")
    }
}
