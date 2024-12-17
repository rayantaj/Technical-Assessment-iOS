//
//  DependencyManager.swift
//  Technical-Assessment
//
//  Created by Rayan Taj on 16/12/2024.
//

import Foundation

class DependencyManager {
    static let shared = DependencyManager()

    private init() {}

    func makeUsersListViewModel() -> UsersListViewModel {
        // Create all dependencies
        let remoteDataSource = UserRemoteDataSource()
        let localDataSource = UserLocalDataSource()
        let repository = UserRepositoryImp(remoteDataSource: remoteDataSource, localDataSource: localDataSource)
        let fetchUsersUseCase = FetchUsersUseCase(repository: repository)
        let viewModel = UsersListViewModel(fetchUsersUseCase: fetchUsersUseCase)

        // Return the view model
        return viewModel
    }
}
