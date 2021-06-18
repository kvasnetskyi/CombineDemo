//
//  UIViewController+Extension.swift
//  CombineDemo
//
//  Created by Roman Savchenko on 08.06.2021.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(okAction)
        present(ac, animated: true, completion: nil)
    }

    func showErrorAlert(errorMessage: String) {
        showAlert(title: "Error", message: errorMessage)
    }
}
