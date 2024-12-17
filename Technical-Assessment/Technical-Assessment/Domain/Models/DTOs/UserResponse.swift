//
//  UserResponse.swift
//  Technical-Assessment
//
//  Created by Rayan Taj on 16/12/2024.
//

import Foundation

// Decodable response models
struct UserResponse: Decodable {
    let code: Int
    let data: [UserDTO]
}


