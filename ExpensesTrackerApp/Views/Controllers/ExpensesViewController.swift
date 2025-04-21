import UIKit
import Combine
import SnapKit

class ExpensesViewController: UIViewController {
    var viewModel: ExpensesViewModel
    private var cancellables = Set<AnyCancellable>()
    private let tableView = UITableView()
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No expenses yet"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    init(viewModel: ExpensesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        setupNavigationBar()
        setupTableView()
        setupEmptyLabel()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Expenses"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(addExpenseTapped)
        )
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = "addExpenseButton"
        let logoutButton = UIBarButtonItem(image: UIImage(systemName: "power.circle.fill"),
                                                   style: .plain,
                                                   target: self,
                                                   action: #selector(logoutTapped))
        navigationItem.leftBarButtonItem = logoutButton
        
    }
    
    private func setupTableView() {
        tableView.register(ExpenseCell.self, forCellReuseIdentifier: "ExpenseCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupEmptyLabel() {
        view.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        viewModel.$expenses
            .receive(on: DispatchQueue.main)
            .sink { [weak self] expenses in
                self?.tableView.reloadData()
                self?.emptyLabel.isHidden = !expenses.isEmpty
            }
            .store(in: &cancellables)
    }
    @objc private func logoutTapped() {
            viewModel.logout()
        }
    @objc private func addExpenseTapped() {
        viewModel.addExpenseTapped()
    }
}

extension ExpensesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath) as? ExpenseCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.expenses[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedExpense = viewModel.expenses[indexPath.row]
        viewModel.editExpenseTapped(expense: selectedExpense)
    }
}


