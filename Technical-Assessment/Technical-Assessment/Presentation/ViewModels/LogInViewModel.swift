//
//  LogInViewModel.swift
//  Technical-Assessment
//
//  Created by Rayan Taj on 15/12/2024.
//

import Foundation


// MARK: - Validation error types | we can add more if needed
enum ValidationError: Error, LocalizedError {
    case emptyInput
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .emptyInput:
            return "Username and password cannot be empty."
        case .unknownError:
            return "Something went wrong, please try again!"

        }
    }
}


class LogInViewModel {
      
    // MARK: - Properties
    var username: String = ""
    var password: String = ""
    
    // MARK: - Handle logIn
    func login(completion: @escaping (Result<String, Error>) -> Void) {
        guard isInputValid() else {
            completion(.failure(ValidationError.emptyInput))
            return
        }
        
        if KeychainHelper.shared.save(password, forKey: "keychain_password") {
            print("successfully saved")
            completion(.success(username))
        } else {
            completion(.failure(ValidationError.unknownError))
        }
    }
    
 
}
// MARK: - LogIn validations helpers
extension LogInViewModel {
    func isInputValid() -> Bool {
        return !username.isEmpty && !password.isEmpty
    }
}
