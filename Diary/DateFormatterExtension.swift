//
//  DateFormatterExtension.swift
//  Diary
//
//  Created by H on 4/30/24.
//

import Foundation

extension DateFormatter {
    static let customDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        return formatter
    }()
    
    static func formatDate(_ date: Date) -> String {
        customDateFormatter.locale = Locale.current
        customDateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return customDateFormatter.string(from: date)
    }
}
