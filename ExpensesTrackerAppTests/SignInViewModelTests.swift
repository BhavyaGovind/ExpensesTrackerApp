//
//  SignInViewModelTests.swift
//  ExpensesTrackerAppTests
//
//  Created by Santosh Govind on 3/27/25.
//

import XCTest
import Combine
@testable import ExpensesTrackerApp

final class SignInViewModelTests: XCTestCase {
    
    var viewModel: SignInViewModel!
    var mockAuthService: MockAuthService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        mockAuthService = MockAuthService()
        viewModel = SignInViewModel(authService: mockAuthService)
    }
    
    override func tearDown() {
        cancellables = nil
        mockAuthService = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testSignIn_Success() {
        let mock_user = ExpensesTrackerApp.User(id: "123", name: "Test", email: "", profileImageUrl: "")
        
        mockAuthService.mockSignInResult = Just(mock_user).setFailureType(to: Error.self).eraseToAnyPublisher()
        
        let expectation = XCTestExpectation(description: "Sign-in completed successfully")
        
        viewModel.$user
            .dropFirst() // Drop the initial nil value
            .sink { user in
                XCTAssertEqual(user?.id, "123", "User ID should match")
                
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Trigger the sign-in action
        viewModel.signIn(presenting: UIViewController())
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSignin_failure() {
        let mockError = NSError(domain: "com.test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Sign-in failed"])
        mockAuthService.mockSignInResult = Fail<User, Error>(error: mockError)
            .eraseToAnyPublisher()

        let expectation = XCTestExpectation(description: "Sign-in failed with error")

        // Subscribe to the view model and check if the user is nil when sign-in fails
        viewModel.signIn(presenting: UIViewController())

        viewModel.$user
            .sink{ user in
                XCTAssertNil(user, "User should be nil if sign-in fails")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Wait for expectations
        wait(for: [expectation], timeout: 1.0)
    }

}
