//
//  AppCoordinator.swift
//  Technical-Assessment
//
//  Created by Rayan Taj on 15/12/2024.
//

import Foundation
import UIKit

// All coordinators must implemnts this protocol.
protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        setLogInViewController()
    }
    
}

// MARK: All Roots ViewControllers needed.
// Set any viewController that can be a root for the app such as, LogIn, SignUp, or Boarding(How-to) to the app.
extension AppCoordinator {
    
    func setLogInViewController() {
        let signupViewController = LogInViewController()
        signupViewController.delegate = self
        navigationController.setViewControllers([signupViewController], animated: false)
    }
    
    
    // we need to set the home as a root after completing login/ to avoid returning back.
    func setHomeViewControllerAsRoot(username: String) {
        let homeViewController = HomeViewController(viewModel: HomeViewModel(username: username))
        homeViewController.delegate = self
        navigationController.setViewControllers([homeViewController], animated: true)
    }
}

// MARK: - ViewControllers that will be pushed in navigation stack
extension AppCoordinator {
    private func startUserListViewController() {
        let userListViewController = UsersListViewController(viewModel: DependencyManager.shared.makeUsersListViewModel())
        navigationController.pushViewController(userListViewController, animated: true)
    }
}


// MARK: LogInViewController delegate to handle navigation
extension AppCoordinator: LogInViewControllerDelegate {
    func goToHomeViewController(username: String) {
        self.setHomeViewControllerAsRoot(username: username)
    }
}

// MARK: LogInViewController delegate to handle navigation
extension AppCoordinator: HomeViewControllerDelegate {
    func goToUserListViewController() {
        self.startUserListViewController()
    }
    

}
