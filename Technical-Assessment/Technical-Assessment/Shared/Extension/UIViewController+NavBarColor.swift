//
//  UIViewController+NavBarColor.swift
//  Technical-Assessment
//
//  Created by Rayan Taj on 16/12/2024.
//

import Foundation
import UIKit

public extension UIViewController {
    func configureNavigationBarColor() {
        self.navigationController?.navigationBar.backgroundColor = .primary
        self.navigationController?.navigationBar.tintColor = .white
        
        let backButtonAppearance = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self])
        backButtonAppearance.setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
        backButtonAppearance.setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .highlighted)
        
        self.navigationController?.navigationBar.titleTextAttributes = [
              .foregroundColor: UIColor.white
          ]
        
        let statusBarView = UIView()
        statusBarView.backgroundColor = .primary // Change to your desired color
        
        // Adjust the frame to match the status bar
        if let statusBarFrame = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame {
            statusBarView.frame = statusBarFrame
            view.addSubview(statusBarView)
        }
    }
}
