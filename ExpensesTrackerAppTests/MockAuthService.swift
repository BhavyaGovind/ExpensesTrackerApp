import Combine
import FirebaseAuth
import UIKit
@testable import ExpensesTrackerApp

// Mock AuthService to simulate Google Sign-In results
class MockAuthService: AuthService {
    
    var mockSignInResult: AnyPublisher<ExpensesTrackerApp.User, Error>!
    var cancellables = Set<AnyCancellable>()
    
    // Override the sign-in method to return the mocked result
    override func signInWithGoogle(presenting viewController: UIViewController) -> Future<ExpensesTrackerApp.User, Error> {
        return Future { promise in
            self.mockSignInResult
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        promise(.failure(error)) // Forward the error
                    }
                }, receiveValue: { user in
                    promise(.success(user)) // Forward the user on success
                })
                .store(in: &self.cancellables)
        }
    }
}
