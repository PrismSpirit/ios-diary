//
//  AlertHelper.swift
//  Diary
//
//  Created by H on 4/30/24.
//

import UIKit

class AlertHelper {
    enum AlertType {
        case onlyConfirm
        case confirmAndCancel
    }
    
    static func showAlert(title: String?, message: String?, type: AlertType, viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        switch type {
        case .onlyConfirm:
            alertController.addAction(.confirmAction)
        case .confirmAndCancel:
            alertController.addAction(.confirmAction)
            alertController.addAction(.cancelAction)
        }
        
        viewController.present(alertController, animated: true)
    }
}
