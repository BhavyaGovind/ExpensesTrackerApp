//
//  AuthServiceTests.swift
//  ExpensesTrackerAppTests
//
//  Created by Santosh Govind on 3/27/25.
//

import XCTest
import Combine
@testable import ExpensesTrackerApp

final class AuthServiceTests: XCTestCase {
    
    var mockAuthService: MockAuthService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockAuthService = MockAuthService()
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        mockAuthService = nil
        super.tearDown()
    }
    
    // Test success case for AuthService's signInWithGoogle
    func testSignInWithGoogle_Success() {
        let mockUser = User(id: "123", name: "Test", email: "", profileImageUrl: "")
        
        // Simulate a successful sign-in response from the mock service
        mockAuthService.mockSignInResult = Just(mockUser)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        // Test that the successful sign-in calls the expected completion
        let expectation = XCTestExpectation(description: "Sign-in successful")
        
        mockAuthService.signInWithGoogle(presenting: UIViewController())
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Sign-in should not have failed")
                }
            }, receiveValue: { user in
                XCTAssertEqual(user.id, "123", "User ID should match")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // Test failure case for AuthService's signInWithGoogle
    func testSignInWithGoogle_Failure() {
        let mockError = NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Sign-in failed"])
        
        // Simulate a failure in the sign-in process
        mockAuthService.mockSignInResult = Fail(error: mockError).eraseToAnyPublisher()
        
        // Test that the failure completion is correctly triggered
        let expectation = XCTestExpectation(description: "Sign-in failed")
        
        mockAuthService.signInWithGoogle(presenting: UIViewController())
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    XCTAssertEqual(error.localizedDescription, "Sign-in failed", "Error should match expected message")
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Sign-in should have failed")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
