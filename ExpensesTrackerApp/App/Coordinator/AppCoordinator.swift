//
//  AppCoordinator.swift
//  ExpensesTracker
//
//  Created by Santosh Govind on 3/6/25.
//

import UIKit
import FirebaseAuth

class AppCoordinator {
    var window: UIWindow
    var navigationController: UINavigationController
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        // Check if user is logged in
        if let _ = Auth.auth().currentUser {
            // User is logged in, navigate to Expenses List
            navigateToExpensesTracker()
        } else {
            // User is not logged in, navigate to Google Sign-In
            navigateToSignIn()
        }
    }
    
    func navigateToSignIn() {
        let signInCoordinator = SignInCoordinator(navigationController: navigationController)
        signInCoordinator.OnSignInSuccess = { [weak self] user in
            self?.navigateToExpensesTracker()
        }
        signInCoordinator.start()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func navigateToExpensesTracker() {
        let expensesCoordinator = ExpensesCoordinator(navigationController: navigationController)
        expensesCoordinator.start()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    
}

