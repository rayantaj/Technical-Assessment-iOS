//
//  UserTableViewCell.swift
//  Technical-Assessment
//
//  Created by Rayan Taj on 16/12/2024.
//

import Foundation
import UIKit

class UserTableViewCell: UITableViewCell {
    
    static let identifier = "UserTableViewCell"
    
    private let nameLabel = UILabel()
    private let genderLabel = UILabel()
    private let emailLabel = UILabel()
    private let statusLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Configure subviews
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = .boldSystemFont(ofSize: 16)
        genderLabel.font = .systemFont(ofSize: 14)
        emailLabel.font = .systemFont(ofSize: 14)
        statusLabel.font = .italicSystemFont(ofSize: 14)
        
        // Add to content view
        contentView.addSubview(nameLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(statusLabel)
        
        // Add constraints
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            emailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            emailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            statusLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    func configure(with user: User) {
        nameLabel.text = user.name
        emailLabel.text = "\(user.email)"
        statusLabel.text = "\(user.status)"
        
        switch user.status {
        case .active:
            statusLabel.textColor = .systemGreen
        case .inactive:
            statusLabel.textColor = .red
        }
    }
}
