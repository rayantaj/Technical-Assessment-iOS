//
//  UserRepository.swift
//  Technical-Assessment
//
//  Created by Rayan Taj on 16/12/2024.
//

import Foundation

protocol UserRepository {
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void)
    func hasLocalData() -> Bool
}
