//
//  FormatStyle+.swift
//  Diary
//
//  Created by Prism, Gama on 4/30/24.
//

import Foundation

extension FormatStyle where Self == Date.FormatStyle {
    static var defaultDateFormatStyle: Date.FormatStyle {
        return Date.FormatStyle(
            date: .abbreviated,
            time: .omitted,
            locale: .autoupdatingCurrent,
            calendar: .autoupdatingCurrent,
            timeZone: .autoupdatingCurrent
        )
    }
}
