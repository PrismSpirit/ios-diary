//
//  AlertHelper.swift
//  Diary
//
//  Created by Prism, Gama on 4/30/24.
//

import UIKit

struct AlertHelper {
    enum AlertType {
        case onlyConfirm
        case confirmAndCancel
    }
    
    static func showAlert(title: String?, message: String?, type: AlertType, viewController: UIViewController, confirm: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
            confirm()
        })
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
    
    static func showActionSheet(title: String?, message: String?, viewController: UIViewController, share: @escaping () -> Void, delete: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: "Share...", style: .default, handler: { _ in
            share()
        })
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.showAlert(title: "진짜요?", message: "정말로 삭제하시겠어요?", type: .confirmAndCancel, viewController: viewController) {
                delete()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(shareAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true)
    }
}
