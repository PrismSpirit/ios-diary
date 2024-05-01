//
//  AlertHelper.swift
//  Diary
//
//  Created by Prism, Gama on 4/30/24.
//

import UIKit

class AlertHelper {
    enum AlertType {
        case onlyConfirm
        case confirmAndCancel
    }
    
    static func showAlert(title: String?, message: String?, type: AlertType, viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        switch type {
        case .onlyConfirm:
            alertController.addAction(confirmAction)
        case .confirmAndCancel:
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
        }
        
        viewController.present(alertController, animated: true)
    }
}
