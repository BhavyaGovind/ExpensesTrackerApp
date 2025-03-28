//
//  ExpenseTableViewCell.swift
//  ExpensesTrackerApp
//
//  Created by Santosh Govind on 3/21/25.
//

import UIKit

class ExpenseTableViewCell: UITableViewCell {

    private var dollarSign:UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "dollarsign.circle"))
        imageView.tintColor = .green
        return imageView
    }()
    
    private var descriptionLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkText
        return label
    }()
    
    private var amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .red
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with expense:Expense) {
        descriptionLabel.text = expense.expenseDescription
        amountLabel.text = String(format: "$%.2f", expense.amount)
    }
    
    func setupUI() {
        contentView.addSubview(dollarSign)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(amountLabel)
        
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        contentView.snp.makeConstraints{ make in
            make.edges.equalToSuperview().inset(4)
        }
        
        dollarSign.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(dollarSign.snp.trailing).offset(12)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
        
    }
}
