//
//  AuthService.swift
//  ExpensesTrackerApp
//
//  Created by Santosh Govind on 3/6/25.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import Combine

protocol AuthServiceProtocol {
    func signInWithGoogle(presenting viewController: UIViewController) -> Future<User, Error>
}

class AuthService: AuthServiceProtocol{
    static let shared = AuthService()
    private var cancellables = Set<AnyCancellable>()

    // Publisher that emits User upon successful Google Sign-In
    func signInWithGoogle(presenting viewController: UIViewController) -> Future<User, Error> {
        return Future { promise in
            GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { signInResult, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }

                guard let signInResult = signInResult else {
                    promise(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "SignIn result is nil."])))
                    return
                }

                // Get ID token and access token
                let user = signInResult.user
                guard let idToken = user.idToken?.tokenString else {
                    promise(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get ID token."])))
                    return
                }

                let accessToken = user.accessToken.tokenString

                // Create Firebase credentials
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

                // Sign in to Firebase with Combine
                self.signInWithFirebase(using: credential)
                    .sink(receiveCompletion: { completion in
                        if case let .failure(error) = completion {
                            promise(.failure(error))
                        }
                    }, receiveValue: { user in
                        promise(.success(user))
                    })
                    .store(in: &self.cancellables)
            }
        }
    }

    private func signInWithFirebase(using credential: AuthCredential) -> Future<User, Error> {
        return Future { promise in
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }

                guard let firebaseUser = authResult?.user else {
                    promise(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to sign in with Firebase."])))
                    return
                }
                
                let user = User.from(firebaseUser: firebaseUser)
                promise(.success(user))
            }
        }
    }
}

