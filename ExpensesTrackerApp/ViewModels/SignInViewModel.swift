//
//  SignInViewModel.swift
//  ExpensesTrackerApp
//
//  Created by Santosh Govind on 3/6/25.
//

import Combine
import UIKit

class SignInViewModel {
    private var cancellables = Set<AnyCancellable>()
    @Published var user: User?
    var coordinator: SignInCoordinator?
    private var authService: AuthServiceProtocol

    init(authService: AuthServiceProtocol = AuthService.shared) {
            self.authService = authService
        }
    func signIn(presenting viewController: UIViewController) {
        authService.signInWithGoogle(presenting: viewController)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Sign-in completed")
                case .failure(let error):
                    print("Sign-in failed with error: \(error.localizedDescription)")
                }
            }, receiveValue: { user in
                self.user = user
                self.coordinator?.didSignInSuccessfully(user: user)
            })
            .store(in: &cancellables)
    }
}

