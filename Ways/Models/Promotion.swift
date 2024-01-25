//
//  Promotion.swift
//  Ways
//
//  Created by Leon on 2024/1/25.
//

import Foundation

struct Promotion: Promotable, Codable {
    var ways: [Way]
    var title: String?
    var subTitle: String?
}
