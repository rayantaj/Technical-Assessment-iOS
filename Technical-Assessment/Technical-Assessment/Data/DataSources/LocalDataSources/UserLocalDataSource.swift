//
//  UserLocalDataSource.swift
//  Technical-Assessment
//
//  Created by Rayan Taj on 16/12/2024.
//

import CoreData

class UserLocalDataSource {
    private let context = CoreDataManager.shared.context

    func saveUsers(_ users: [User]) {
        // Clear existing data
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = UserEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Failed to clear existing users: \(error)")
        }

        // Save new users
        users.forEach { user in
            let userEntity = UserEntity(context: context)
            userEntity.id = Int64(user.id)
            userEntity.name = user.name
            userEntity.email = user.email
            userEntity.gender = user.gender
            userEntity.status = user.status.rawValue
        }

        do {
            try context.save()
        } catch {
            print("Failed to save users: \(error)")
        }
    }

    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        do {
            let userEntities = try context.fetch(fetchRequest)
            let users = userEntities.map { entity in
                User(
                    id: Int(entity.id),
                    name: entity.name ?? "",
                    gender: entity.gender ?? "",
                    email: entity.email ?? "",
                    status: User.UserStatus(rawValue: entity.status ?? "") ?? .inactive
                )
            }
            completion(.success(users))
        } catch {
            completion(.failure(error))
        }
    }
    
    func hasUsers() -> Bool {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.fetchLimit = 1 // Only check if at least one user exists
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking local data: \(error)")
            return false
        }
    }
}
