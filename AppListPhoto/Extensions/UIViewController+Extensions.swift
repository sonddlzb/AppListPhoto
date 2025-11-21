//
//  UIViewController+Extensions.swift
//  AppListPhoto
//
//  Created by đào sơn on 22/11/25.
//

import UIKit

extension UIViewController {
    func showAlert(title: String? = nil,
                   message: String? = nil,
                   completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: completion)
        }
    }
}
