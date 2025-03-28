//
//  SignInViewController.swift
//  ExpensesTrackerApp
//
//  Created by Santosh Govind on 3/6/25.
//

import UIKit

class SignInViewController: UIViewController {
    var viewModel = SignInViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SignInViewController - viewDidLoad")
        setupUI()
    }

    
    func setupUI() {
        self.title = "SignIn"
        self.view.backgroundColor = UIColor.systemBackground
        
        let signInButton = UIButton()
        signInButton.setTitle("Sign In with Google", for: .normal)
        signInButton.accessibilityIdentifier = "signInButton" // to identify the element in UI testing
        signInButton.setTitleColor(.blue, for: .normal)
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        
        view.addSubview(signInButton)
        signInButton.snp.makeConstraints{ make in
            make.center.equalToSuperview()
        }
    }
    
    @objc func signInTapped() {
        viewModel.signIn(presenting: self)
    }

}
