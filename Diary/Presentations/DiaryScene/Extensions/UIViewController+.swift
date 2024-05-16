//
//  UIViewController+.swift
//  Diary
//
//  Created by Jaehun Lee on 5/16/24.
//

import UIKit

extension UIViewController {
    func showToast(message: String, result: Result<Void, Never>) {
        let toastLabel: UILabel = {
            let label = UILabel()
            label.backgroundColor = .systemBackground.withAlphaComponent(0.8)
            label.text
        }()
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}
