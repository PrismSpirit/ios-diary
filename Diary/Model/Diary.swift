//
//  Diary.swift
//  Diary
//
//  Created by Prism, Gama on 4/30/24.
//

import Foundation

struct Diary: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var body: String
    var editedDate: Date
    
    func formatDate() -> String {
        return editedDate.formatted(.defaultDateFormatStyle)
    }
}
