//
//  UIViewController+ShowErrorAlert.swift
//  Technical-Assessment
//
//  Created by Rayan Taj on 17/12/2024.
//

import Foundation
import UIKit

public extension UIViewController {
    
    func showErrorAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
