//
//  UserRemoteDataSource.swift
//  Technical-Assessment
//
//  Created by Rayan Taj on 16/12/2024.
//
import Foundation

class UserRemoteDataSource {
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        guard let url = URL(string: "https://gorest.co.in/public-api/users") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 404, userInfo: nil)))
                return
            }

            do {
                let response = try JSONDecoder().decode(UserResponse.self, from: data)
                let users = response.data.map { user in
                    User(id: user.id, name: user.name, gender: user.gender, email: user.email, status: User.UserStatus.init(rawValue: user.status) ?? .inactive)
                }
                completion(.success(users))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
