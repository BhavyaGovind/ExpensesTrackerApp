//
//  AppCoordinator.swift
//  ExpensesTracker
//
//  Created by Santosh Govind on 3/6/25.
//

import UIKit
import FirebaseAuth

class AppCoordinator: ExpensesCoordinatorDelegate{
    var window: UIWindow
    var navigationController: UINavigationController
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        
        if ProcessInfo.processInfo.environment["UITest"] == "1" {
            print("Running in UITest mode: Skipping authentication")
            navigateToExpensesTracker()
            return
        }
        // Check if user is logged in
        if let _ = Auth.auth().currentUser {
            
            print("Current user, \(Auth.auth().currentUser)")
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
        expensesCoordinator.delegate = self
        window.rootViewController = navigationController
        navigationController.setViewControllers([expensesCoordinator.rootViewController], animated: true)
        window.makeKeyAndVisible()
    }
    
    func didSignOut() {
        navigationController.setViewControllers([], animated: false)
        navigateToSignIn()
    }
    
    
}

