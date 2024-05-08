//
//  ReuseIdentifiable.swift
//  Diary
//
//  Created by Prism, Gama on 5/2/24.
//

import Foundation

protocol ReuseIdentifiable {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
