//
//  AddExpenseViewModelTests.swift
//  ExpensesTrackerAppTests
//
//  Created by Santosh Govind on 3/31/25.
//

import XCTest
import Combine
@testable import ExpensesTrackerApp

final class AddExpenseViewModelTests: XCTestCase {
    
    var viewModel: AddExpenseViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        viewModel = AddExpenseViewModel()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    // Validation Fails when Amount is 0 or Negative
    func testValidationFailsForInvalidAmount() {
        viewModel.amount.send(0.0)
        viewModel.expenseDescription.send("Valid Description")
        
        let errorMessage = viewModel.validateAndSaveExpense()
        
        XCTAssertEqual(errorMessage, "Invalid amount")
    }
    
    // Validation Fails when Description is Empty
    func testValidationFailsForEmptyDescription() {
        viewModel.amount.send(10.0)
        viewModel.expenseDescription.send("")
        
        let errorMessage = viewModel.validateAndSaveExpense()
        
        XCTAssertEqual(errorMessage, "Description cannot be empty")
    }
    
    // Validation Passes for Valid Inputs
    func testValidationPassesForValidInputs() {
        viewModel.amount.send(10.0)
        viewModel.expenseDescription.send("Valid Expense")
        
        let errorMessage = viewModel.validateAndSaveExpense()
        
        XCTAssertNil(errorMessage)
    }
    
    // Amount Updates Correctly
    func testAmountUpdates() {
        let expectation = expectation(description: "Amount should update")
        
        viewModel.amount
            .dropFirst() //To Void initial Value in CurrentValueSubject
            .sink { value in
            XCTAssertEqual(value, 20.0)
            expectation.fulfill()
        }.store(in: &cancellables)
        
        viewModel.amount.send(20.0)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // Description Updates Correctly
    func testDescriptionUpdates() {
        let expectation = expectation(description: "Description should update")
        
        viewModel.expenseDescription
            .dropFirst() //To Void initial Value in CurrentValueSubject
            .sink { value in
            XCTAssertEqual(value, "New Expense")
            expectation.fulfill()
        }.store(in: &cancellables)
        
        viewModel.expenseDescription.send("New Expense")
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // Should Allow Valid Number Input
    func testShouldAllowValidNumberInput() {
        let result = viewModel.shouldAllowChange(currentText: "12", range: NSRange(location: 2, length: 0), replacementString: "3")
        XCTAssertTrue(result)
    }
    
    // Should Prevent Multiple Decimal Points
    func testShouldPreventMultipleDecimalPoints() {
        let result = viewModel.shouldAllowChange(currentText: "12.3", range: NSRange(location: 4, length: 0), replacementString: ".")
        XCTAssertFalse(result)
    }
    
    // Save Expense is Called on Successful Validation
    func testSaveExpenseCalledOnValidInputs() {
        let expectation = expectation(description: "Save expense should be called")
        
        viewModel.amount.send(50.0)
        viewModel.expenseDescription.send("Lunch")
        
        let errorMessage = viewModel.validateAndSaveExpense()
        
        XCTAssertNil(errorMessage)
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    
    
}
