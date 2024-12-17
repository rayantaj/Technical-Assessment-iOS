//
//  FetchUsersUseCase.swift
//  Technical-Assessment
//
//  Created by Rayan Taj on 16/12/2024.
//

import Foundation

class FetchUsersUseCase {
    private let repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }

    func execute(completion: @escaping (Result<[User], Error>) -> Void) {
        repository.fetchUsers(completion: completion)
    }
}
