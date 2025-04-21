//
//  ExpenseTableViewCell.swift
//  ExpensesTrackerApp
//
//  Created by Santosh Govind on 3/21/25.
//

import UIKit

class ExpenseCell: UITableViewCell {
    private let containerView = UIView()
    private let amountLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.layer.borderColor = UIColor.gray.cgColor
        
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        amountLabel.font = .systemFont(ofSize: 18, weight: .bold)
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .medium)
        descriptionLabel.textColor = .black
        amountLabel.textColor = .black
        
        let stackView = UIStackView(arrangedSubviews: [amountLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        containerView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
    }
    
    func configure(with expense: Expense) {
        amountLabel.text = "$\(expense.amount)"
        descriptionLabel.text = expense.expenseDescription
    }
}
