//
//  UIAlertActionExtension.swift
//  Diary
//
//  Created by H on 4/30/24.
//

import UIKit

extension UIAlertAction {
    static var confirmAction: UIAlertAction {
        return UIAlertAction(title: "확인", style: .default)
    }
    
    static var cancelAction: UIAlertAction {
        return UIAlertAction(title: "취소", style: .cancel)
    }
}
