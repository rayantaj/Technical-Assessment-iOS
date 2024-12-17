//
//  LogInViewController.swift
//  Technical-Assessment
//
//  Created by Rayan Taj on 15/12/2024.
//
import UIKit

protocol LogInViewControllerDelegate: AnyObject {
    func goToHomeViewController(username: String)
}


class LogInViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel = LogInViewModel()
    weak var delegate: LogInViewControllerDelegate?

    // MARK: - UI Elements
    
    lazy var welcomeLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .primary
        view.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        view.text = "Hello,"
        return view
    }()
    
    lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "Username"
        textField.returnKeyType = .next
        textField.addTarget(self, action: #selector(usernameTextChanged), for: .editingChanged)
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        textField.addTarget(self, action: #selector(passwordTextChanged), for: .editingChanged)
        return textField
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .primary
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        renderUI()
        setupSubViews()
        setupKeyboardDismissGesture()
    }
}

// MARK: - ViewController layout protocol implemntation
extension LogInViewController: VCLayoutProtocol {
    func renderUI() {
        view.addSubview(welcomeLabel)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        setupConstraints()
        setupStyling()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            usernameTextField.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            usernameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupStyling() {
        view.backgroundColor = .systemBackground
    }
    
    func setupSubViews() {
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
}

// MARK: - UITextField Actions

extension LogInViewController {
    @objc private func usernameTextChanged() {
        viewModel.username = usernameTextField.text ?? ""
    }
    
    @objc private func passwordTextChanged() {
        viewModel.password = passwordTextField.text ?? ""
    }
}

// MARK: - UITextFieldDelegate

extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            loginButtonTapped()
        }
        return true
    }
}

// MARK: - Actions

extension LogInViewController {
    @objc private func loginButtonTapped() {
        viewModel.login { [weak self] result in
        
                switch result {
                case .success(let username):
                    self?.delegate?.goToHomeViewController(username: username)
                case .failure(let error):
                    self?.showErrorAlert(title: "Error", message: error.localizedDescription)
                }
            
        }
    }
}
