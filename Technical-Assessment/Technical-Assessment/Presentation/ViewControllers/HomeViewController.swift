//
//  HomeViewController.swift
//  Technical-Assessment
//
//  Created by Rayan Taj on 15/12/2024.
//

import Foundation
import UIKit

protocol HomeViewControllerDelegate: AnyObject {
    func goToUserListViewController()
}

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel: HomeViewModel
    weak var delegate: HomeViewControllerDelegate?
    
    // MARK: - UIViews
    private var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private var headerView: HeaderView = {
        let view = HeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var messageInputContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    
    private var messageTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter message"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy private var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Send", for: .normal)
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let socketStatusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.text = "Connecting..."
        return label
    }()
    
    lazy var SocketButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("-", for: .normal)
        button.backgroundColor = .primary
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(socketButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var messageInputBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Initilizer
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        
        renderUI()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        viewModel.delegate = self
        viewModel.triggerWebSocket()
        
    }
    
    // Based on your buissness, you can disconnect your socket when home vc will disappear
    override func viewWillDisappear(_ animated: Bool) {
//        viewModel.disConnectSocket()
    }
    
}

// MARK: - ViewController layout protocol implemntation
extension HomeViewController: VCLayoutProtocol {
    func renderUI() {
        
        view.addSubview(containerView)
        containerView.addSubview(headerView)
        containerView.addSubview(socketStatusLabel)
        containerView.addSubview(SocketButton)
        
        view.addSubview(messageInputContainer)
        messageInputContainer.addSubview(messageTextField)
        messageInputContainer.addSubview(sendButton)
        
        setupConstraints()
        setupStyling()
        setupSubViews()
    }
    
    func setupConstraints() {
        
        messageInputBottomConstraint = messageInputContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        view.addConstraints([
            
            // Main container
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Header view
            headerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60),
            
            // Spcket status label
            socketStatusLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 30),
            socketStatusLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            socketStatusLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            // Socket button
            SocketButton.topAnchor.constraint(equalTo: socketStatusLabel.bottomAnchor, constant: 30),
            SocketButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 50),
            SocketButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -50),
            
            // Message input container
            messageInputBottomConstraint,
            messageInputContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageInputContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageInputContainer.heightAnchor.constraint(equalToConstant: 50),
            
            // Text field
            messageTextField.leadingAnchor.constraint(equalTo: messageInputContainer.leadingAnchor, constant: 8),
            messageTextField.centerYAnchor.constraint(equalTo: messageInputContainer.centerYAnchor),
            messageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            
            // Send button
            sendButton.trailingAnchor.constraint(equalTo: messageInputContainer.trailingAnchor, constant: -8),
            sendButton.centerYAnchor.constraint(equalTo: messageInputContainer.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 60)
            
        ])
    }
    
    func setupStyling() {
        view.backgroundColor = .primary
        configureNavigationBarColor()
    }
    
    func setupSubViews() {
        headerView.delegate = self
        headerView.configure(title: "Hello, \(viewModel.username)", buttonTitle: "Users list")
    }
}

// MARK: - HeaderView Delegate
extension HomeViewController: HeaderViewDelegate {
    func headerButtonTapped() {
        self.delegate?.goToUserListViewController()
    }
}

// MARK: - ViewModel Delegate
extension HomeViewController: HomeViewModelDelegate {
    func connectedSuccessfully() {
        socketStatusLabel.text = "Connected to WebSocket"
        SocketButton.setTitle("Disconnect", for: .normal)
        
    }
    
    func disconnected() {
        socketStatusLabel.text = "Disconnected to WebSocket"
        SocketButton.setTitle("Connect", for: .normal)
        
    }
    
    func showRecivedMessage(_ message: String) {
        showErrorAlert(title: "", message: message)
    }
}

// MARK: - Buttons actions
extension HomeViewController {
    
    @objc private func socketButtonTapped() {
        viewModel.triggerWebSocket()
        
    }
    
    @objc private func sendButtonTapped() {
        guard let message = messageTextField.text, !message.isEmpty else {
            self.showErrorAlert(title: "Error", message: "Message cannot be empty")
            return
        }
        viewModel.sendMassage(message: message)
        messageTextField.text = ""
    }
}

// MARK: - Handle Keyboard
extension HomeViewController {
    
    @objc private func handleKeyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        messageInputBottomConstraint.constant = -keyboardFrame.height
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func handleKeyboardWillHide(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }
        
        messageInputBottomConstraint.constant = 0
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}
