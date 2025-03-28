//
//  SignInCoordinator.swift
//  ExpensesTrackerApp
//
//  Created by Santosh Govind on 3/6/25.
//

import UIKit

class SignInCoordinator {
    
    var navigationController: UINavigationController
  var OnSignInSuccess: ((User) -> Void)? //Closure to notify AppCoordinator
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let signInVC = SignInViewController()
        signInVC.viewModel = SignInViewModel()
        signInVC.viewModel.coordinator = self
        navigationController.pushViewController(signInVC, animated: true)
        print("SiginViewController presented")
    }
    
    func didSignInSuccessfully(user: User) {
        OnSignInSuccess?(user)
    }
}

