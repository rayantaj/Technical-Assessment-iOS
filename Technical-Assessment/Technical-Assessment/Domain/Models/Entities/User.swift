//
//  User.swift
//  Technical-Assessment
//
//  Created by Rayan Taj on 16/12/2024.
//

import Foundation

struct User: Codable {
    let id: Int
    let name: String
    let gender: String
    let email: String    
    let status: UserStatus
    
    enum UserStatus: String, Codable {
        case active = "active"
        case inactive = "inactive"
    }
}
