//
//  HeaderView.swift
//  Technical-Assessment
//
//  Created by Rayan Taj on 16/12/2024.
//

import Foundation
import UIKit

// Protocol for delegating button actions
protocol HeaderViewDelegate: AnyObject {
    func headerButtonTapped()
}

class HeaderView: UIView {
    
    // MARK: - Properties
    weak var delegate: HeaderViewDelegate?

    // Title label
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        return label
    }()

    // Button
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Action", for: .normal)
        button.setTitleColor(.primary, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Setup Methods
    private func setupView() {
        // Add subviews
        addSubview(titleLabel)
        addSubview(actionButton)
        self.backgroundColor = .primary
        // Setup constraints
        NSLayoutConstraint.activate([
            // Title Label
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            // Action Button
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            actionButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: 40),
            actionButton.widthAnchor.constraint(equalToConstant: 80)
        ])
    }

    // Configure the view with a title
    func configure(title: String, buttonTitle: String) {
        titleLabel.text = title
        actionButton.setTitle(buttonTitle, for: .normal)
    }

    // MARK: - Actions
    @objc private func buttonTapped() {
        delegate?.headerButtonTapped()
    }
}
