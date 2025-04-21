//
//  SignInViewController.swift
//  ExpensesTrackerApp
//
//  Created by Santosh Govind on 3/6/25.
//

import UIKit

class SignInViewController: UIViewController {
    
    var viewModel = SignInViewModel()
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 60, weight: .medium)
        imageView.image = UIImage(systemName: "creditcard.fill", withConfiguration: config)
        imageView.tintColor = .systemBlue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SignInViewController - viewDidLoad")
        setupUI()
    }

    
    func setupUI() {
        self.title = "SignIn"
        self.view.backgroundColor = UIColor.systemBackground

        // 1. Add Logo
        let logoImageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 60, weight: .semibold, scale: .large)
        logoImageView.image = UIImage(systemName: "creditcard.fill", withConfiguration: config)
        logoImageView.tintColor = .systemBlue
        view.addSubview(logoImageView)

        // 2. Add Button
        let signInButton = UIButton(type: .system)
        signInButton.setTitle("Continue with Google", for: .normal)
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        signInButton.backgroundColor = UIColor.systemBlue
        signInButton.layer.cornerRadius = 10
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        signInButton.layer.shadowColor = UIColor.black.cgColor
        signInButton.layer.shadowOpacity = 0.15
        signInButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        signInButton.layer.shadowRadius = 6
        signInButton.layer.masksToBounds = false
        view.addSubview(signInButton)

        // 3. Add Constraints
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-60)
            make.width.equalToSuperview().multipliedBy(0.35)
            make.height.equalTo(logoImageView.snp.width)
        }

        signInButton.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(44)
        }

        // 4. Add Animation
        animateLogo(logoImageView)
    }


    func animateLogo(_ logo: UIImageView) {
        logo.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: [.repeat, .autoreverse],
                       animations: {
            logo.transform = CGAffineTransform.identity
        }, completion: nil)
    }

    
    
    @objc func signInTapped() {
        viewModel.signIn(presenting: self)
    }

}
