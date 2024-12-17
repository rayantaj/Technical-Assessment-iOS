//
//  UsersListViewController 2.swift
//  Technical-Assessment
//
//  Created by Rayan Taj on 16/12/2024.
//
import UIKit

class UsersListViewController: UIViewController {
   
    private var viewModel: UsersListViewModel
    
    private var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        return tableView
    }()

    init(viewModel: UsersListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        renderUI()
        setupStyling()
        setupSubViews()
        
        viewModel.delegate = self // Set the delegate
        viewModel.loadUsers() // Trigger user loading
    }

  
}

// MARK: - ViewController layout protocol implemntation
extension UsersListViewController: VCLayoutProtocol {
    func renderUI() {
        
        view.addSubview(containerView)
        containerView.addSubview(tableView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: containerView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    func setupStyling() {
        title = "Users"
        view.backgroundColor = .primary
        configureNavigationBarColor()
    }
    
    func setupSubViews() {
        tableView.dataSource = self
        tableView.delegate = self
    }
   
}


// MARK: - UITableViewDataSource, UITableViewDelegate
extension UsersListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as? UserTableViewCell else {
            return UITableViewCell()
        }
        let user = viewModel.users[indexPath.row]
        cell.configure(with: user)
        return cell
    }
}

// MARK: - UsersListViewModelDelegate
extension UsersListViewController: UsersListViewModelDelegate {
    func didRecieveError(errorMassage: String) {
        self.showErrorAlert(title: "Error", message: errorMassage)
    }
    
    func didLoadUsers() {
        tableView.reloadData() // Refresh the table view
    }
}
