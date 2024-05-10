//
//  Diary.swift
//  Diary
//
//  Created by Prism, Gama on 4/30/24.
//

import Foundation

struct Diary: Identifiable, Hashable {
    let id: UUID
    let body: String
    let editedDate: Date
}
