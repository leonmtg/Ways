//
//  DateFormater+.swift
//  Ways
//
//  Created by Leon on 2024/1/16.
//

import Foundation

extension DateFormatter {
    public static let yearMonthDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
