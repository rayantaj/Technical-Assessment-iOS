//
//  UIViewController+HideKeyboard.swift
//  Technical-Assessment
//
//  Created by Rayan Taj on 15/12/2024.
//

import UIKit

public extension UIViewController {
    
    func setupKeyboardDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true) // Dismiss the keyboard
    }
}
