//
//  UserRepositoryImp.swift
//  Technical-Assessment
//
//  Created by Rayan Taj on 16/12/2024.
//

class UserRepositoryImp: UserRepository {
    private let remoteDataSource: UserRemoteDataSource
    private let localDataSource: UserLocalDataSource

    init(remoteDataSource: UserRemoteDataSource, localDataSource: UserLocalDataSource) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        if hasLocalData() {
            print("Fetch Locally")
            localDataSource.fetchUsers(completion: completion)
        } else {
            print("Fetch remote")
            remoteDataSource.fetchUsers { [weak self] result in
                if case .success(let users) = result {
                    self?.localDataSource.saveUsers(users) // Cache data locally
                }
                completion(result)
            }
        }
    }
    
    func hasLocalData() -> Bool {
          return localDataSource.hasUsers()
      }
}
