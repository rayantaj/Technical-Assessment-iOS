//
//  UsersListViewModel.swift
//  Technical-Assessment
//
//  Created by Rayan Taj on 16/12/2024.
//

import Foundation

// MARK: - Link ViewModel with ViewController
protocol UsersListViewModelDelegate: AnyObject {
    func didLoadUsers()
    func didRecieveError(errorMassage: String)
}

class UsersListViewModel {
    
    // MARK: - Properties
    let fetchUsersUseCase: FetchUsersUseCase
    weak var delegate: UsersListViewModelDelegate?
    
    // MARK: - Users(data source for tableview)
    var users: [User] = []
    
    init(fetchUsersUseCase: FetchUsersUseCase) {
        self.fetchUsersUseCase = fetchUsersUseCase
    }
    
    // MARK: - fecth users list, usecase will handle if will fetch from local or reomtley
    func loadUsers() {
        fetchUsersUseCase.execute { [weak self] result in
            switch result {
            case .success(let users):
                self?.users = users
                DispatchQueue.main.async {
                    self?.delegate?.didLoadUsers()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.delegate?.didRecieveError(errorMassage: error.localizedDescription)
                }
            }
        }
        
    }
}

