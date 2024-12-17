//
//  UserDTO.swift
//  Technical-Assessment
//
//  Created by Rayan Taj on 16/12/2024.
//


struct UserDTO: Decodable {
    let id: Int
    let name: String
    let email: String
    let gender: String
    let status: String
}
