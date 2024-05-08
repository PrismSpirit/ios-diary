//
//  DiaryDTO.swift
//  Diary
//
//  Created by Prism, Gama on 4/30/24.
//

import Foundation

struct DiaryDTO: Decodable {
    let title: String
    let body: String
    let createdAt: Int

    private enum CodingKeys: String, CodingKey {
        case title
        case body
        case createdAt = "created_at"
    }
}

extension DiaryDTO {
    func toModel() -> Diary {
        return .init(title: title,
                     body: body,
                     editedDate: Date(timeIntervalSince1970: TimeInterval(createdAt)))
    }
}
