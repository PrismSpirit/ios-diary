//
//  Array+.swift
//  Diary
//
//  Created by Jaehun Lee on 5/2/24.
//

extension Array {
    subscript (safeIndex index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
