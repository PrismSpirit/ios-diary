//
//  DecodingError+.swift
//  Diary
//
//  Created by Prism, Gama on 4/30/24.
//

import Foundation

extension DecodingError {
    var localizedDescription: String {
        switch self {
        case .dataCorrupted:
            return "데이터가 손상되었습니다."
        case let .keyNotFound(codingKey, context):
            return "\(codingKey) 값을 찾지 못했습니다."
        case let .valueNotFound(value, context):
            return "\(value) 값을 찾지 못했습니다."
        case let .typeMismatch(type, context):
            return "\(type)이/가 일치하지 않습니다."
        @unknown default:
            return "알 수 없는 디코딩 에러가 발생했습니다."
        }
    }
}
