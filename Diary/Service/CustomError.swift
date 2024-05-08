//
//  CustomError.swift
//  Diary
//
//  Created by H on 5/5/24.
//

import Foundation

enum CustomErorr: Error {
    case invalidFileName
    
    var localizedDescription: String {
        switch self {
        case .invalidFileName:
            return "해당하는 파일명을 찾지 못했습니다."
        }
    }
}
