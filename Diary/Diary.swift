//
//  TempData.swift
//  Diary
//
//  Created by prism, gama on 4/30/24.
//

import Foundation

struct Diary: Codable {
    let title: String
    let body: String
    let createdAt: Int

    private enum CodingKeys: String, CodingKey {
        case title
        case body
        case createdAt = "created_at"
    }
}
